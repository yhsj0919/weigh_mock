import 'package:fast_gbk/fast_gbk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Map Json扩展方法
extension WidgetExtension on Widget {
  Widget icon(Widget icon, {double padding: 8, CrossAxisAlignment alignment: CrossAxisAlignment.center}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [icon, Container(width: padding), Flexible(child: this)],
    );
  }

  Widget endWith(List<Widget> widgets) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        this,
        Expanded(child: Container()),
        ...widgets,
      ],
    );
  }

  Widget rowWith(List<Widget> widgets) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this,
        ...widgets,
      ],
    );
  }

  Widget showBy(bool show) {
    if (show) {
      return this;
    } else {
      return Container();
    }
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget flexible({bool enable = true, int flex = 1}) {
    return enable
        ? Flexible(
            flex: flex,
            child: this,
          )
        : this;
  }

  Widget keyListener({ValueChanged<RawKeyEvent>? onkey}) {
    return RawKeyboardListener(
      focusNode: FocusNode(canRequestFocus: false),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyUpEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.select) {
            // print('>>>>>>>>>点击了确定>>>>>>>>>');
          } else {
            // print('>>>>>>>>>点击了>>${event.logicalKey}>>>>>>>');
          }

          onkey?.call(event);
        }
      },
      child: this,
    );
  }

  Widget width(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  Widget center() {
    return Center(
      child: this,
    );
  }

  Widget size({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget clipRRect({double radius = 5}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: this,
    );
  }
}

extension mapExt on Map<String, dynamic>? {
  Map<String, dynamic> page({int? page, int? size}) {
    var params = this ?? {};
    params["page"] = page ?? 0;
    params["size"] = size ?? 20;

    return params;
  }
}

extension CodingEXt on String {
  String get toGBK {
    return gbk.decode(codeUnits);
  }
}

extension ExtensionGlobalKey on GlobalKey<FormState> {
  bool validate() {
    if (currentState?.validate() == true) {
      currentState?.save();
      return true;
    } else {
      return false;
    }
  }
}

extension NumExt on String? {
  double toDouble({double? def}) {
    return double.tryParse(toString().trim()) ?? def ?? 0.0;
  }

  int toInt() {
    return int.tryParse(toString().trim()) ?? 0;
  }
}
