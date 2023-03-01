// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionMenu extends StatefulWidget {
  const ExpansionMenu({
    Key? key,
    required this.title,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.action = const <Widget>[],
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.expandedAlignment,
    this.minHeight,
    this.minWidth,
    this.borderWidth,
    this.elevation = 1,
    this.expandIcon,
  }) : super(key: key);

  final Widget title;

  final ValueChanged<bool>? onExpansionChanged;

  final List<Widget> children;
  final List<Widget> action;

  final bool initiallyExpanded;

  final bool maintainState;
  final double? minWidth;
  final double? minHeight;
  final double? borderWidth;
  final double? elevation;
  final Icon? expandIcon;

  final Alignment? expandedAlignment;

  @override
  _ExpansionMenuState createState() => _ExpansionMenuState();
}

class _ExpansionMenuState extends State<ExpansionMenu> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) widget.onExpansionChanged!(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: constraints.biggest.width < (widget.minWidth ?? 400) + 300 ? 8 : 20),
          elevation: widget.elevation,
          child: SizedBox(
            // radius: 0,
            // shadowColor: Colors.redAccent,
            // elevation: 0,
            // borderWidth: widget.borderWidth ?? 1,
            width: widget.minWidth,
            height: widget.minHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      widget.title,
                      Expanded(child: Container()),
                      ...widget.action,
                      widget.children.isNotEmpty
                          ? IconButton(
                              constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                              icon: widget.expandIcon ?? RotationTransition(turns: _iconTurns, child: const Icon(Icons.expand_more)),
                              onPressed: _handleTap)
                          : Container(
                              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            )
                    ],
                  ),
                ),
                ClipRect(
                  child: Align(
                    alignment: widget.expandedAlignment ?? Alignment.center,
                    heightFactor: _heightFactor.value,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 15,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
