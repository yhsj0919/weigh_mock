import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weigh_mock/utils/ext.dart';
import 'package:weigh_mock/utils/serial/serial.dart';
import 'package:weigh_mock/utils/validator.dart';
import 'package:weigh_mock/weigh_controller.dart';
import 'package:weigh_mock/widget/form/label_form.dart';
import 'package:weigh_mock/widget/form/radio_button_form.dart';
import 'package:weigh_mock/widget/form/spinner.dart';
import 'package:weigh_mock/widget/form/spinner_form.dart';
import 'package:weigh_mock/widget/form/text_form.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  WeighController weighController = Get.put(WeighController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设置"), centerTitle: true),
      body: Form(
        key: weighController.formKey,
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinnerForm(
                labelText: "串口",
                value: SpinnerItem(id: weighController.weighParams["name"], name: weighController.weighParams["name"]),
                itemBuilder: () {
                  return Serial.getSerials().then((value) {
                    return value.map((e) => SpinnerItem(id: e.name, name: "${e.name} ${(e.description ?? "").toGBK}")).toList();
                  });
                },
                validator: (item) => emptyValidator(item?.id, "不可为空"),
                onSaved: (item) {
                  weighController.weighParams["name"] = item?.id;
                },
              ).width(350),
              TextForm(
                labelText: "波特率",
                initialValue: "${weighController.weighParams["rate"] ?? 9600}",
                validator: (value) => numberValidator(value, "请输入数字"),
                onSaved: (value) {
                  weighController.weighParams["rate"] = int.tryParse(value!);
                },
              ).width(350),
              RadioButtonForm(
                labelText: "数据类型",
                value: RadioItem(id: weighController.weighParams["dataType"]),
                items: [
                  RadioItem(id: "3190", name: "□+00000001D□"),
                  RadioItem(id: "3168", name: "FF 11 00 00 00"),
                ],
                onChanged: (value) {
                  weighController.weighParams["dataType"] = value.id;
                },
              ).width(350),
              Container(height: 16),
              ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue), //背景颜色
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                      onPressed: () {
                        weighController.saveConfig();
                      },
                      child: const Text("保存配置"))
                  .width(250)
                  .rowWith([
                Container(width: 30),
                ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.redAccent), //背景颜色
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        ),
                        onPressed: () {
                          weighController.deleteConfig();
                        },
                        child: const Text("删除"))
                    .width(70)
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
