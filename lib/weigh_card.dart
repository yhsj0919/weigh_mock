import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weigh_mock/utils/ext.dart';

typedef CardListener = void Function(int index, double weigh);

class WeighCard extends StatefulWidget {
  const WeighCard({Key? key, this.width, this.height, this.index, this.link, this.weigh, this.stabilize, this.listener}) : super(key: key);
  final double? width;
  final double? height;
  final int? index;
  final bool? link;
  final bool? stabilize;
  final double? weigh;
  final CardListener? listener;

  @override
  State<WeighCard> createState() => _WeighCardState();
}

class _WeighCardState extends State<WeighCard> {
  RxBool hover = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        // onHover: (value) {
        //   hover.value = value;
        // },
        // onTap: widget.weigh != null
        //     ? () {
        //         widget.listener?.call(widget.index ?? 1, formatNum(widget.weigh, 2).toDouble());
        //       }
        //     : null,
        child: Stack(
          children: [
            Obx(() => Container(
                  width: widget.width,
                  height: widget.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: widget.link == true ? Colors.black : Colors.black,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: hover.value ? Border.all(color: Colors.red, width: 3) : null),
                  child: Text(formatNum(widget.weigh, 2) ?? "ERR",
                      style: TextStyle(color: Colors.red, fontSize: widget.weigh != null ? 100 : 95, fontFamily: widget.weigh != null ? "FX-LED" : "LED2")),
                )),
            Container(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.all(4),
                width: 20,
                height: 20,
                decoration: BoxDecoration(color: widget.stabilize == true ? Colors.green : Colors.red, borderRadius: const BorderRadius.all(Radius.circular(30))),
              ),
            ),
            Container(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Icon(widget.link == true ? Icons.link : Icons.link_off, color: widget.link == true ? Colors.green : Colors.red, size: 30),
            ),
            Container(
              width: widget.width,
              height: widget.height,
              alignment: Alignment.topLeft,
              // color: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text("${widget.index ?? ""}", style: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: "FX-LED")),
            ),
          ],
        ));
  }

  String? formatNum(double? num, int postion) {
    if (num == null) return null;

    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) < postion) {
      return num.toStringAsFixed(postion).substring(0, num.toString().lastIndexOf(".") + postion + 1).toString();
    } else {
      return num.toString().substring(0, num.toString().lastIndexOf(".") + postion + 1).toString();
    }
  }
}
