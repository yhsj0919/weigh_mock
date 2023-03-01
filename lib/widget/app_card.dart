import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCard extends StatefulWidget {
  AppCard({
    Key? key,
    this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.color = Colors.white70,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.border,
    this.isShadow = false,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.all(0),
  }) : super(key: key);
  final Widget? child;
  final double? width;
  final double? height;
  final Color color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final bool isShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  _AppCardState createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: Get.width < 700 ? const EdgeInsets.symmetric(vertical: 8, horizontal: 8) : widget.padding,
      margin: widget.margin,
      //边框设置
      decoration: BoxDecoration(
        //背景
        color: widget.color,
        //设置四周圆角 角度
        borderRadius: widget.borderRadius,
        //设置四周边框
        border: widget.border,
        boxShadow: widget.isShadow
            ? [
                const BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 0.0), //阴影x轴偏移量
                    blurRadius: 2, //阴影模糊程度
                    spreadRadius: 0 //阴影扩散程度
                    )
              ]
            : null,
      ),
      child: widget.child,
    );
  }
}
