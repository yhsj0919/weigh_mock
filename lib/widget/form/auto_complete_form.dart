// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../auto_complete_text_field.dart';

export 'package:flutter/services.dart' show SmartQuotesType, SmartDashesType;

///AutoCompleteForm 必须重写自定义对象T的toString方法,使返回值与item显示的相同,不然onSave可能会获取不到值
class AutoCompleteForm<T extends Object> extends FormField<T> {
  AutoCompleteForm({
    Key? key,
    this.onChanged,
    this.controller,
    T? value,
    String? labelText,
    String? hintText,
    TextStyle? style,
    bool autofocus = false,
    bool necessary = false,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    bool? enabled,
    int debounceTime = 600,
    bool showWithEmpty = false,
    required OptionsBuilder<T> optionsBuilder,
    required OptionsViewBuilder optionsViewBuilder,
    OnSelected<T>? onSelected,
    this.refresh,
    WrapAlignment labelAlignment = WrapAlignment.start,
    TextStyle? labelStyle,
  }) : super(
          key: key,
          initialValue: value,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? true,
          builder: (FormFieldState<T> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0x12000000)),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: AutoCompleteTextField(
                      value: state.value,
                      controller: controller,
                      debounceTime: debounceTime,
                      showWithEmpty: showWithEmpty,
                      textStyle: style,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        hintText: hintText,
                        isCollapsed: true,
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 1)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 4)),
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        onChanged?.call(value);
                        if (T == String) {
                          state.didChange.call(value);
                        } else if (state.value.toString() != value) {
                          state.didChange.call(null);
                        }
                      },
                      optionsBuilder: optionsBuilder,
                      optionsViewBuilder: optionsViewBuilder,
                      onSelected: (value) {
                        state.didChange.call(value);
                        onSelected?.call(value as T);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );

  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Object? refresh;

  @override
  FormFieldState<T> createState() => _TextFormFieldState<T>();
}

class _TextFormFieldState<T extends Object> extends FormFieldState<T> {
  @override
  AutoCompleteForm<T> get widget => super.widget as AutoCompleteForm<T>;

  @override
  void didChange(T? value) {
    super.didChange(value);
  }

  @override
  void didUpdateWidget(AutoCompleteForm<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue || oldWidget.refresh != widget.refresh) {
      setValue(widget.initialValue);
    }
  }

// @override
// void dispose() {
//   widget.controller?.dispose();
//   super.dispose();
// }
}
