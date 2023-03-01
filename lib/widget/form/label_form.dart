// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelForm extends FormField<String> {
  LabelForm({
    Key? key,
    this.onChanged,
    String? initialValue,
    String? labelText,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    bool necessary = false,
    bool showBorder = false,
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
    WrapAlignment labelAlignment = WrapAlignment.start,
    TextStyle? labelStyle,
    TextStyle? style,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled,
          builder: (FormFieldState<String> field) {
            final _TextFormFieldState state = field as _TextFormFieldState;

            final child = Text(state.value ?? "", style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: alignment,
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
                showBorder
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0x12000000)),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: child,
                            ),
                            const Divider(color: Colors.black, height: 1, indent: 0, endIndent: 0),
                          ],
                        ),
                      )
                    : Padding(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2), child: child),
              ],
            );
          },
        );

  final ValueChanged<String?>? onChanged;

  @override
  FormFieldState<String> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  @override
  LabelForm get widget => super.widget as LabelForm;

  @override
  void didChange(String? value) {
    super.didChange(value);
  }

  @override
  void didUpdateWidget(LabelForm oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
      widget.onChanged?.call(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
