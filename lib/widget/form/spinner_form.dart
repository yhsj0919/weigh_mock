// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:weigh_mock/widget/form/spinner.dart';

/// A convenience widget that makes a [DropdownButton] into a [FormField].
class SpinnerForm extends FormField<SpinnerItem> {
  /// Creates a [DropdownButton] widget that is a [FormField], wrapped in an
  /// [InputDecorator].
  ///
  /// For a description of the `onSaved`, `validator`, or `autovalidateMode`
  /// parameters, see [FormField]. For the rest (other than [decoration]), see
  /// [DropdownButton].
  ///
  /// The `items`, `elevation`, `iconSize`, `isDense`, `isExpanded`,
  /// `autofocus`, and `decoration`  parameters must not be null.
  SpinnerForm({
    Key? key,
    String? labelText,
    required this.itemBuilder,
    //这个值用来刷新接口请求,两次传入的值不同,itemBuilder就会重新请求
    this.requestKey,
    this.initData = true,
    DropdownButtonBuilder? selectedItemBuilder,
    SpinnerItem? value,
    Widget? hint,
    Widget? disabledHint,
    this.onChanged,
    VoidCallback? onTap,
    int elevation = 8,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    bool necessary = false,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool autofocus = false,
    Color? dropdownColor,
    InputDecoration? decoration,
    FormFieldSetter<SpinnerItem>? onSaved,
    FormFieldValidator<SpinnerItem>? validator,
    double? menuMaxHeight,
    TextStyle? labelStyle,
    WrapAlignment labelAlignment = WrapAlignment.start,
  })  : assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        decoration = decoration ?? InputDecoration(focusColor: focusColor),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<SpinnerItem> field) {
            final _DropdownButtonFormFieldState state = field as _DropdownButtonFormFieldState;
            return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              labelText == null ? Container() : Container(height: 8),
              labelText == null
                  ? Container()
                  : Wrap(
                      alignment: labelAlignment,
                      children: [
                        Container(height: 8),
                        necessary ? const Text("*", style: TextStyle(color: Colors.red)) : Container(),
                        Text(labelText, style: labelStyle),
                        Container(width: 8),
                        Text(field.errorText ?? "", style: const TextStyle(color: Colors.red)),
                      ],
                    ),
              labelText == null ? Container() : Container(height: 6),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0x12000000)),
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Spinner(
                          itemBuilder: itemBuilder,
                          initData: initData,
                          requestKey: requestKey,
                          selectedItemBuilder: selectedItemBuilder,
                          value: state.value,
                          hint: hint,
                          disabledHint: disabledHint,
                          onChanged: state.didChange,
                          onTap: onTap,
                          elevation: elevation,
                          style: style,
                          icon: icon,
                          iconDisabledColor: iconDisabledColor,
                          iconEnabledColor: iconEnabledColor,
                          iconSize: iconSize,
                          isDense: isDense,
                          isExpanded: isExpanded,
                          itemHeight: itemHeight,
                          focusColor: focusColor,
                          focusNode: focusNode,
                          autofocus: autofocus,
                          dropdownColor: dropdownColor,
                          menuMaxHeight: menuMaxHeight,
                        )),
                    const Divider(color: Colors.black45, height: 1, indent: 0, endIndent: 0),
                  ],
                ),
              )
            ]);
          },
        );

  final ValueChanged<SpinnerItem?>? onChanged;
  final InputDecoration decoration;
  final ItemBuilder itemBuilder;
  final dynamic requestKey;
  final bool initData;

  @override
  FormFieldState<SpinnerItem> createState() => _DropdownButtonFormFieldState();
}

class _DropdownButtonFormFieldState extends FormFieldState<SpinnerItem> {
  @override
  SpinnerForm get widget => super.widget as SpinnerForm;

  @override
  void didChange(SpinnerItem? value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }

  @override
  void didUpdateWidget(SpinnerForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
    if (oldWidget.itemBuilder != widget.itemBuilder || oldWidget.initData != widget.initData || oldWidget.requestKey != widget.requestKey) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) => didChange(widget.initialValue));
    }
  }
}
