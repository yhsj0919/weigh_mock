/*
 * Based on libserialport (https://sigrok.org/wiki/Libserialport).
 *
 * Copyright (C) 2010-2012 Bert Vermeulen <bert@biot.com>
 * Copyright (C) 2010-2015 Uwe Hermann <uwe@hermann-uwe.de>
 * Copyright (C) 2013-2015 Martin Ling <martin-libserialport@earth.li>
 * Copyright (C) 2013 Matthias Heidbrink <m-sigrok@heidbrink.biz>
 * Copyright (C) 2014 Aurelien Jacobs <aurel@gnuage.org>
 * Copyright (C) 2020 J-P Nurmi <jpnurmi@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:libserialport/src/bindings.dart';
import 'package:libserialport/src/dylib.dart';
import 'package:libserialport/src/error.dart';
import 'package:libserialport/src/port.dart';
import 'package:weigh_mock/utils/ext.dart';

const int _kReadEvents = sp_event.SP_EVENT_RX_READY | sp_event.SP_EVENT_ERROR;

/// Asynchronous serial port reader.
///
/// Provides a [stream] that can be listened to asynchronously to receive data
/// whenever available.
///
/// The [stream] will attempt to open a given [port] for reading. If the stream
/// fails to open the port, it will emit [SerialPortError]. If the port is
/// successfully opened, the stream will begin emitting [Uint8List] data events.
///
/// **Note:** The reader must be closed using [close()] when done with reading.
abstract class SerialPortReader {
  /// Creates a reader for the port. Optional [timeout] parameter can be
  /// provided to specify a time im milliseconds between attempts to read after
  /// a failure to open the [port] for reading. If not given, [timeout] defaults
  /// to 500ms.
  /// bytes 封包字节大小，使用之后可能导致显示不正确，请确认之后填写(如Hello World为11个字节)
  /// startByte 开始帧，防止第一帧数据异常导致的固定封包失败,请确保该帧唯一（如第一帧获取到llo。。会导致所有的封包变成llo WorldHe 导致所有数据不正确，通过这个参数舍弃错误帧,不连续的数据可能会导致第一帧丢失，最好别单独用）
  /// startHex 必须和bytes一起使用，开始帧，防止第一帧数据异常导致的固定封包失败,请确保该帧唯一（如第一帧获取到llo。。会导致所有的封包变成llo WorldHe 导致所有数据不正确，通过这个参数舍弃错误帧,不连续的数据可能会导致第一帧丢失，最好别单独用）
  factory SerialPortReader(SerialPort port, {int? timeout, int? bytes, int? startByte, int? endByte, String? startHex}) =>
      _SerialPortReaderImpl(port, timeout: timeout, bytes: bytes, startByte: startByte, endByte: endByte, startHex: startHex);

  /// Gets the port the reader operates on.
  SerialPort get port;

  /// Gets a stream of data.
  Stream<Uint8List> get stream;

  /// Closes the stream.
  void close();
}

class _SerialPortReaderArgs {
  final int address;
  final int timeout;
  final SendPort sendPort;

  _SerialPortReaderArgs({
    required this.address,
    required this.timeout,
    required this.sendPort,
  });
}

class _SerialPortReaderImpl implements SerialPortReader {
  final SerialPort _port;
  final int _timeout;
  final int? _bytes;
  final int? _startByte;
  final String? _startHex;
  final int? _endByte;
  Isolate? _isolate;
  ReceivePort? _receiver;
  StreamController<Uint8List>? __controller;

  final List<int> myData = [];

  _SerialPortReaderImpl(SerialPort port, {int? timeout, int? bytes, int? startByte, int? endByte, String? startHex})
      : _port = port,
        _timeout = timeout ?? 500,
        _bytes = bytes,
        _startByte = startByte,
        _startHex = startHex,
        _endByte = endByte;

  @override
  SerialPort get port => _port;

  @override
  Stream<Uint8List> get stream => _controller.stream;

  @override
  void close() {
    __controller?.close();
    __controller = null;
  }

  StreamController<Uint8List> get _controller {
    return __controller ??= StreamController<Uint8List>(
      onListen: _startRead,
      onCancel: _cancelRead,
      onPause: _cancelRead,
      onResume: _startRead,
    );
  }

  void _startRead() {
    _receiver = ReceivePort();
    _receiver!.listen((data) {
      if (data is SerialPortError) {
        _controller.addError(data);
      } else if (data is Uint8List) {
        if (_bytes != null || _startByte != null || _endByte != null || _startHex != null) {
          for (var element in data) {
            ///清除第一帧不匹配的数据
            if (_startByte != null && myData.isNotEmpty && myData.first != _startByte) {
              myData.clear();
            }

            ///判断数据是不是等于startHex，必须和byte一起使用
            if (_startHex?.isNotEmpty == true && myData.isNotEmpty) {
              var hex = myData.map((e) => e.toRadixString(16).padLeft(2, '0')).join().toUpperCase();

              if (hex.length <= _startHex!.length) {
                if (!_startHex!.toUpperCase().startsWith(hex)) {
                  myData.clear();
                }
              }
            }

            ///如果只配置了启动帧，则在清除数据之前发送出去
            if (element == _startByte) {
              if (myData.isNotEmpty && _bytes == null) {
                _controller.add(Uint8List.fromList(myData));
              }
              myData.clear();
            }
            myData.add(element);

            ///把符合长度的数据发送出去
            if (_bytes != null && myData.length >= _bytes!) {
              _controller.add(Uint8List.fromList(myData));
              myData.clear();
            }

            ///把符合结尾的数据发送出去
            if (_endByte != null && myData.isNotEmpty && myData.last == _endByte) {
              _controller.add(Uint8List.fromList(myData));
              myData.clear();
            }
          }
        } else {
          _controller.add(data);
        }
      }
    });
    final args = _SerialPortReaderArgs(
      address: _port.address,
      timeout: _timeout,
      sendPort: _receiver!.sendPort,
    );
    Isolate.spawn(
      _waitRead,
      args,
      debugName: toString(),
    ).then((value) => _isolate = value);
  }

  void _cancelRead() {
    _receiver?.close();
    _receiver = null;
    _isolate?.kill();
    _isolate = null;
  }

  // static void _waitRead(_SerialPortReaderArgs args) {
  //   final port = ffi.Pointer<sp_port>.fromAddress(args.address);
  //   final events = _createEvents(port, _kReadEvents);
  //   var bytes = 0;
  //   while (bytes >= 0) {
  //     bytes = _waitEvents(port, events, args.timeout);
  //     if (bytes > 0) {
  //       final data = Util.read(bytes, (ffi.Pointer<ffi.Uint8> ptr) {
  //         return dylib.sp_nonblocking_read(port, ptr.cast(), bytes);
  //       });
  //       args.sendPort.send(data);
  //     } else if (bytes < 0) {
  //       args.sendPort.send(SerialPort.lastError);
  //     }
  //   }
  //   _releaseEvents(events);
  // }
  static void _waitRead(_SerialPortReaderArgs args) {
    SerialPort port = SerialPort.fromAddress(args.address);
    while (port.isOpen) {
      // Read a single byte. This is a blocking call which will timeout after args.timeout ms.
      Uint8List first;
      try {
        first = port.read(1, timeout: args.timeout);
      } catch (e) {
        // print('>>>>>>>出现异常>>>>>>>>');
        first = Uint8List.fromList([]);
      }

      if (first.isNotEmpty) {
        // Send the single byte
        args.sendPort.send(first);
        // Read the rest of the data available.
        var toRead = port.bytesAvailable;
        if (toRead > 0) {
          try {
            var remaining = port.read(toRead);
            if (remaining.isNotEmpty) {
              args.sendPort.send(remaining);
            }
          } catch (e) {
            print('>>>报了个错>>>${e.toString().toGBK}');
          }
        }
      }
    }
  }

  static ffi.Pointer<ffi.Pointer<sp_event_set>> _createEvents(
    ffi.Pointer<sp_port> port,
    int mask,
  ) {
    final events = ffi.calloc<ffi.Pointer<sp_event_set>>();
    dylib.sp_new_event_set(events);
    dylib.sp_add_port_events(events.value, port, mask);
    return events;
  }

  static int _waitEvents(
    ffi.Pointer<sp_port> port,
    ffi.Pointer<ffi.Pointer<sp_event_set>> events,
    int timeout,
  ) {
    dylib.sp_wait(events.value, timeout);
    return dylib.sp_input_waiting(port);
  }

  static void _releaseEvents(ffi.Pointer<ffi.Pointer<sp_event_set>> events) {
    dylib.sp_free_event_set(events.value);
  }
}
