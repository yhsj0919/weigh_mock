import 'package:flutter/material.dart';

class AppTitleMenu extends StatefulWidget {
  const AppTitleMenu({
    Key? key,
    required this.title,
    this.menus: const [],
    this.rightPadding: 0,
  }) : super(key: key);

  final Widget title;
  final List<Widget> menus;
  final double rightPadding;

  @override
  _AppTitleMenuState createState() => _AppTitleMenuState();
}

class _AppTitleMenuState extends State<AppTitleMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 14, right: widget.rightPadding),
      child: Row(
        children: [Expanded(child: widget.title)]..addAll(widget.menus),
      ),
    );
  }
}
