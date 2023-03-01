// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

typedef DataBuilder<T> = Future<List<T>> Function();
typedef ItemBuilder<T> = Widget Function(T? select, T data);

class WrapForm<T> extends FormField<T> {
  WrapForm({
    Key? key,
    String? labelText,
    required this.dataBuilder,
    required this.itemBuilder,
    //这个值用来刷新接口请求,两次传入的值不同,itemBuilder就会重新请求
    this.requestKey,
    this.requestKey2,
    this.initData = true,
    T? value,
    this.onChanged,
    VoidCallback? onTap,
    int elevation = 8,
    TextStyle? labelStyle,
    bool necessary = false,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    double? menuMaxHeight,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          builder: (FormFieldState<T> field) {
            final _WrapFormFieldState state = field as _WrapFormFieldState;
            return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 8),
              Wrap(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 8),
                  necessary ? const Text("*", style: TextStyle(color: Colors.red)) : Container(),
                  Text(labelText ?? "", style: labelStyle),
                  Container(width: 8),
                  Text(field.errorText ?? "", style: const TextStyle(color: Colors.red)),
                ],
              ),
              Container(height: 8),
              Wrap(
                runSpacing: 16,
                spacing: 16,
                children: state.datas.map((e) {
                  return ActionChip(
                    avatar: CircleAvatar(
                      backgroundColor: e.toString() == state.value.toString() ? Colors.blue : Colors.black26,
                      child: e.toString() == state.value.toString() ? const Icon(Icons.done, color: Colors.white) : null,
                    ),
                    label: itemBuilder.call(state.value, e),
                    onPressed: () {
                      //刷新Form数据,用于校验
                      state.didChange(e);
                      //表单回调
                      onChanged?.call(e);
                    },
                  );
                }).toList(),
              ),
              Container(height: 8),
            ]);
          },
        );

  final ValueChanged<T?>? onChanged;

  final DataBuilder<T> dataBuilder;
  final ItemBuilder<T> itemBuilder;
  final dynamic requestKey;
  final dynamic requestKey2;
  final bool initData;

  @override
  FormFieldState<T> createState() => _WrapFormFieldState();
}

class _WrapFormFieldState<T> extends FormFieldState<T> {
  List<T> datas = [];

  @override
  WrapForm<T> get widget => super.widget as WrapForm<T>;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void didUpdateWidget(WrapForm<T> oldWidget) {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (oldWidget.requestKey == widget.requestKey && value != widget.initialValue) {
        didChange(widget.initialValue);
        widget.onChanged?.call(widget.initialValue);
      }
      if (oldWidget.initialValue != widget.initialValue ||
          (oldWidget.initData != widget.initData) ||
          oldWidget.requestKey2 != widget.requestKey2 ||
          (oldWidget.requestKey != widget.requestKey)) {
        getData().then((_) {
          var current = value;

          if (current == null || oldWidget.initialValue != widget.initialValue) {
            didChange(widget.initialValue);

            widget.onChanged?.call(widget.initialValue);
          } else {
            var newValue = datas.where((element) => element.toString() == value.toString()).toList();

            if (newValue.isNotEmpty) {
              didChange(newValue.first);

              widget.onChanged?.call(newValue.first);
            } else {
              didChange(widget.initialValue);

              widget.onChanged?.call(widget.initialValue);
            }
          }
        });
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  Future getData() {
    return widget.dataBuilder.call().then((value) {
      setState(() {
        datas.clear();
        datas.addAll(value);
      });
    });
  }
}
