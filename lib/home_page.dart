import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weigh_mock/setting_page.dart';
import 'package:weigh_mock/utils/ext.dart';
import 'package:weigh_mock/utils/serial/serial.dart';
import 'package:weigh_mock/weigh_card.dart';
import 'package:weigh_mock/weigh_controller.dart';
import 'package:weigh_mock/widget/app_widget.dart';
import 'package:weigh_mock/widget/form/radio_button_form.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeighController weighController = Get.put(WeighController());
  RxDouble value = RxDouble(0);
  double max = 999;
  RxInt divisions = RxInt(1);

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      weighController.write(value.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "images/bg.png",
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => WeighCard(
                            width: 330,
                            height: 190,
                            link: weighController.serialStatus.value == SerialStatus.rw,
                            stabilize: weighController.stabilize.value,
                            weigh: value.value,
                          )),
                      Container(width: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() =>
                              weighController.refreshMap.value == -1 ? subtitle("text") : subtitle("${weighController.weighParams["name"] ?? ""}").icon(const Icon(Icons.usb))),
                          Obx(() => weighController.refreshMap.value == -1
                              ? subtitle("text")
                              : subtitle("${weighController.weighParams["rate"] ?? ""}").icon(const Icon(Icons.line_axis_outlined))),
                          Obx(() => weighController.refreshMap.value == -1
                              ? subtitle("text")
                              : subtitle("${weighController.weighParams["dataType"] ?? ""}").icon(const Icon(Icons.merge_type_outlined))),
                          RadioButtonForm(
                            labelText: "步进",
                            items: [
                              RadioItem(id: "1", name: "1"),
                              RadioItem(id: "10", name: "0.1"),
                              RadioItem(id: "100", name: "0.01"),
                            ],
                            onChanged: (item) {
                              divisions.value = item.id.toInt();
                            },
                          ),
                          ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blue), //背景颜色
                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                  ),
                                  onPressed: () {
                                    weighController.start();
                                  },
                                  child: const Text("模拟"))
                              .width(100)
                              .rowWith([
                            Container(width: 16),
                            ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.redAccent), //背景颜色
                                      foregroundColor: MaterialStateProperty.all(Colors.white),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                    ),
                                    onPressed: () {
                                      weighController.close();
                                    },
                                    child: const Text("停止"))
                                .width(70)
                          ]),
                        ],
                      ),
                    ],
                  ),
                  Container(height: 65),
                  Obx(() => Slider(
                        value: value.value,

                        onChanged: (v) {
                          value.value = v;
                          // weighController.write(v);
                        },
                        //气泡的值
                        label: value.toStringAsFixed(2),
                        //进度条上显示多少个刻度点
                        divisions: (max * divisions.value).toInt(),
                        max: max,
                        min: 0,
                      )).width(450),
                ],
              ),
            )),
        Container(
          width: double.infinity,
          // margin: EdgeInsets.only(top: 8),
          height: 40,
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Flexible(
                  child: DragToMoveArea(
                child: Container(
                  width: double.infinity,
                  height: 40,
                ),
              )),
              IconButton(
                  onPressed: () {
                    Get.to(const SettingPage());
                  },
                  icon: const Icon(Icons.settings)),
              IconButton(
                  onPressed: () {
                    windowManager.minimize();
                  },
                  icon: const Icon(Icons.minimize)),
              IconButton(
                  onPressed: () {
                    windowManager.close();
                  },
                  icon: const Icon(Icons.close)),
              Container(width: 20)
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
