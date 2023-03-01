import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weigh_mock/utils/ext.dart';
import 'package:weigh_mock/utils/serial/ext.dart';
import 'package:weigh_mock/utils/serial/serial.dart';
import 'package:weigh_mock/utils/sp.dart';
import 'package:weigh_mock/widget/message.dart';

class WeighController extends GetxController {
  final formKey = GlobalKey<FormState>();

  var weighParams = {};

  RxDouble result = RxDouble(0.0);
  final RxDouble _weigh = RxDouble(0.0);

  RxString raw = RxString("");
  Rx<SerialStatus> serialStatus = Rx<SerialStatus>(SerialStatus.none);

  Serial? serial;

  StreamSubscription<Uint8List>? listener;
  StreamSubscription<SerialStatus>? statusListener;

  ///数据稳定管理
  StreamSubscription<dynamic>? stabilizeFuture;

  ///稳定地磅数据
  RxBool stabilize = RxBool(false);

  RxInt refreshMap = RxInt(0);
  double tmp = 0;

  @override
  void onInit() {
    super.onInit();
    weighParams = Sp.get("config") ?? {};

    serial = Serial(name: "");

    listener ??= serial?.valueStream.listen((value) {
      _weigh.value = result.value;
    });

    statusListener ??= serial?.statusStream.listen(
      (value) {
        serialStatus.value = value;
      },
      onError: (e) {
        showError("串口开启失败:${e.toString()}");
      },
    );
  }

  Future<void> saveConfig() async {
    if (formKey.validate()) {
      refreshMap.value = Random().nextInt(1000);
      await Sp.set("config", weighParams);
    }
  }

  Future<void> deleteConfig() async {
    await Sp.remove("config");
    weighParams = {};
  }

  void start() {
    if (weighParams["name"] == null) {
      showError('检查串口配置');
      return;
    }

    serial?.name = weighParams["name"];
    serial?.rate = weighParams["rate"];
    serial?.start();
  }

  void write(double num) {
    // if (serial?.status != SerialStatus.rw) {
    //   showError("串口异常");
    //   return;
    // }

    if ((tmp - num).abs() > 0) {
      startStabilize();
    }
    tmp = num;

    if (weighParams["dataType"] == "3168") {
      serial?.write(num.restore3168().hexToUint8List);
    } else {
      serial?.write(num.restore3190().uint8List);
    }
  }

  ///地磅稳定状态
  void startStabilize() {
    stabilizeFuture?.cancel();
    stabilize.value = false;

    stabilizeFuture = Future.delayed(const Duration(seconds: 1)).asStream().listen((value) {
      stabilize.value = true;
    });
  }

  void close() {
    serial?.close();
  }

  void disposeSerial() {
    stabilizeFuture?.cancel();
    result.value = 0.0;
    _weigh.value = 0.0;
    raw.value = "";
    serialStatus.value = SerialStatus.none;
    listener?.cancel();
    listener = null;
    statusListener?.cancel();
    statusListener = null;
    serial?.dispose();
    serial = null;
  }

  @override
  void onClose() {
    close();
    super.onClose();
  }

  @override
  void dispose() {
    disposeSerial();
    super.dispose();
  }
}
