import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget listTitle(String text) => Text(text, style: TextStyle(fontSize: Theme.of(Get.context!).textTheme.subtitle1?.fontSize), overflow: TextOverflow.ellipsis);

Widget subtitle(String text, {Color? color, int? maxLines}) =>
    Text(text, maxLines: maxLines, style: Theme.of(Get.context!).textTheme.subtitle1?.copyWith(color: color), overflow: TextOverflow.ellipsis);

Widget title(String text, {Color? color, int? maxLines, TextAlign? textAlign}) => Text(
      text,
      maxLines: maxLines,
      style: Theme.of(Get.context!).textTheme.headline6?.copyWith(color: color),
      textAlign: textAlign,
    );

Widget smallTitle(String text, {int? maxLines}) => Text(text, style: const TextStyle(color: Colors.black45, fontSize: 12), maxLines: maxLines, overflow: TextOverflow.ellipsis);

Widget body(String text, {Color? color}) => Text(text, style: Theme.of(Get.context!).textTheme.bodyText1?.copyWith(color: color));

Widget bigTextTip(String text) => Text(text, style: Theme.of(Get.context!).textTheme.headline4?.copyWith(color: Colors.black26));

Widget bigText(String text) => Text(text, style: Theme.of(Get.context!).textTheme.headline4?.copyWith(color: Colors.black87));

Widget text(String text, {Color? color, double? size}) => Text(text, style: Theme.of(Get.context!).textTheme.bodyText1?.copyWith(color: color ?? Colors.black87, fontSize: size));

Widget line({double? width, double indent = 12, double endIndent = 12}) {
  return Container(
    margin: EdgeInsets.only(left: indent, right: endIndent),
    height: 1,
    width: width,
    color: Colors.black12,
  );
}

Widget button({String? text, EdgeInsetsGeometry margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 16), required VoidCallback onPressed, Color? color}) {
  return Padding(
    padding: margin,
    child: MaterialButton(
      child: text == null ? null : Text(text, style: const TextStyle(color: Colors.white)),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
      height: 43,
      minWidth: 80,
      color: color ?? Colors.blue,
      onPressed: onPressed,
    ),
  );
}
