// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

export 'package:flutter/services.dart' show SmartQuotesType, SmartDashesType;

class TextForm extends FormField<String> {
  TextForm({
    Key? key,
    this.controller,
    String? initialValue,
    String? labelText,
    FocusNode? focusNode,
    // InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? labelStyle,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    bool necessary = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    this.onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(0.0),
    bool enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    ScrollController? scrollController,
    Widget? suffixIcon,
    String? restorationId,
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
    WrapAlignment labelAlignment = WrapAlignment.start,
  })  : assert(initialValue == null || controller == null),
        assert(obscuringCharacter.length == 1),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength == TextField.noMaxLength || maxLength > 0),
        super(
          key: key,
          initialValue: controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled ?? true,
          builder: (FormFieldState<String> field) {
            final _TextFormState state = field as _TextFormState;
            //这里用来绑定数据
            void onChangedHandler(String value) {
              //刷新Form数据,用于校验
              field.didChange(value);
              //表单回调
              if (onChanged != null) {
                onChanged(value);
              }
            }

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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0x12000000)),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: TextField(
                      restorationId: restorationId,
                      controller: state._effectiveController,
                      focusNode: focusNode,
                      // decoration: effectiveDecoration,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        suffixIcon: suffixIcon,
                        isCollapsed: true,
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide(color: state.errorText == null ? Colors.black87 : Colors.red, width: state.errorText == null ? 1 : 3)),
                        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 4)),
                      ),
                      keyboardType: keyboardType,
                      textInputAction: textInputAction,
                      style: style,
                      strutStyle: strutStyle,
                      textAlign: textAlign,
                      textAlignVertical: textAlignVertical,
                      textDirection: textDirection,
                      textCapitalization: textCapitalization,
                      autofocus: false,
                      toolbarOptions: toolbarOptions,
                      readOnly: readOnly,
                      showCursor: showCursor,
                      obscuringCharacter: obscuringCharacter,
                      obscureText: obscureText,
                      autocorrect: autocorrect,
                      smartDashesType: smartDashesType ?? (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
                      smartQuotesType: smartQuotesType ?? (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
                      enableSuggestions: enableSuggestions,
                      maxLengthEnforcement: maxLengthEnforcement,
                      maxLines: maxLines,
                      minLines: minLines,
                      expands: expands,
                      maxLength: maxLength,
                      onChanged: onChangedHandler,
                      onTap: onTap,
                      onEditingComplete: onEditingComplete,
                      onSubmitted: onFieldSubmitted,
                      inputFormatters: inputFormatters,
                      enabled: enabled ?? true,
                      cursorWidth: cursorWidth,
                      cursorHeight: cursorHeight,
                      cursorRadius: cursorRadius,
                      cursorColor: cursorColor,
                      scrollPadding: scrollPadding,
                      scrollPhysics: scrollPhysics,
                      keyboardAppearance: keyboardAppearance,
                      enableInteractiveSelection: enableInteractiveSelection,
                      selectionControls: selectionControls,
                      buildCounter: buildCounter,
                      autofillHints: autofillHints,
                      scrollController: scrollController,
                    ),
                  ),
                ),
              ],
            );
          },
        );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  ValueChanged<String>? onChanged;

  @override
  FormFieldState<String> createState() => _TextFormState();
}

class _TextFormState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController => widget.controller ?? _controller;

  @override
  TextForm get widget => super.widget as TextForm;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
      widget.onChanged?.call(widget.initialValue ?? "");
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TextForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) _controller = TextEditingController.fromValue(oldWidget.controller!.value);
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }

    if (oldWidget.initialValue != widget.initialValue || widget.initialValue != _effectiveController?.text) {
      _effectiveController?.text = widget.initialValue ?? "";
      setValue(widget.initialValue);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
  }

  @override
  void reset() {
    _effectiveController!.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    if (_effectiveController!.text != value) didChange(_effectiveController!.text);
  }
}
