import 'dart:async';
import 'dart:typed_data';

import 'package:libserialport/libserialport.dart';

import 'reader.dart' as Ex;

enum SerialStatus {
  none,
  open,
  rw,
  close,
  error,
}

class Serial {
  static Future<List<SerialPort>> getSerials() {
    return Future(() => SerialPort.availablePorts.map((e) => SerialPort(e)).toList());
  }

  SerialStatus status = SerialStatus.none;

  Stream<Uint8List> get valueStream => _valueController.stream;

  StreamController<Uint8List>? __valueController;

  StreamController<Uint8List> get _valueController {
    return __valueController ??= StreamController<Uint8List>(
      onCancel: () {
        print('raw cancel');
      },
      onListen: () {
        print('raw listen');
      },
    );
  }

  Stream<SerialStatus> get statusStream => _statusStreamController.stream;

  StreamController<SerialStatus>? __statusStreamController;

  StreamController<SerialStatus> get _statusStreamController {
    return __statusStreamController ??= StreamController<SerialStatus>(
      onCancel: () {
        print('status cancel');
      },
      onListen: () {
        print('status listen');
      },
    );
  }

  String name;
  SerialPort? port;
  int? rate;
  Ex.SerialPortReader? _reader;

  /// bytes 封包字节大小，使用之后可能导致显示不正确，请确认之后填写(如Hello World为11个字节)
  int? bytes;

  /// startByte 开始帧，防止第一帧数据异常导致的固定封包失败,请确保该帧唯一（如第一帧获取到llo。。会导致所有的封包变成llo WorldHe 导致所有数据不正确，通过这个参数舍弃错误帧,不连续的数据可能会导致第一帧丢失，最好别单独用）
  int? startByte;

  /// startHex 必须和bytes一起使用，开始帧，防止第一帧数据异常导致的固定封包失败,请确保该帧唯一（如第一帧获取到llo。。会导致所有的封包变成llo WorldHe 导致所有数据不正确，通过这个参数舍弃错误帧,不连续的数据可能会导致第一帧丢失，最好别单独用）
  String? startHex;

  ///endByte结束帧，遇到结束帧会返回数据，防止数据不完整
  int? endByte;

  Serial({required this.name, this.rate, this.bytes, this.startHex, this.startByte, this.endByte});

  void start() {
    if (name.isEmpty) {
      print('请配置端口');
      return;
    }
    close();
    port = SerialPort(name);
    _statusStreamController.add(SerialStatus.open);
    if (!port!.openReadWrite()) {
      status = SerialStatus.error;
      _statusStreamController.add(SerialStatus.error);
      print(SerialPort.lastError);
      return;
    }
    config(baudRate: rate);
    status = SerialStatus.rw;
    _statusStreamController.add(SerialStatus.rw);

    _reader = Ex.SerialPortReader(port!, bytes: bytes, startHex: startHex, startByte: startByte, endByte: endByte);
    _reader!.stream.listen((event) {
      _valueController.add(event);
    });
  }

  void close() {
    _reader?.close();
    port?.close();
    status = SerialStatus.close;
    _statusStreamController.add(SerialStatus.close);
  }

  void dispose() {
    __valueController?.close();
    __valueController = null;
    __statusStreamController?.close();
    __statusStreamController = null;

    close();
  }

  void write(Uint8List bytes) {
    port?.write(bytes);
  }

  void config({int? baudRate}) {
    var config = port!.config;
    config.baudRate = baudRate ?? 4800;
    config.bits = 8;
    config.stopBits = 1;
    config.parity = 0;
    config.dtr = 0;
    config.rts = 0;
    config.cts = 0;
    config.dsr = 0;

    port!.config = config; //Had to add this
  }
}
