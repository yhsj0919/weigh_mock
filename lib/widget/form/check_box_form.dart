import 'package:flutter/material.dart';

class CheckBoxForm extends StatefulWidget {
  CheckBoxForm({
    Key? key,
    this.labelText,
    this.onChanged,
    this.value,
    this.activeText,
    this.inactiveText,
  }) : super(key: key);
  final String? labelText;
  final String? activeText;
  final String? inactiveText;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  @override
  _CheckBoxFormState createState() => _CheckBoxFormState();
}

class _CheckBoxFormState extends State<CheckBoxForm> {
  late bool switchValue;

  @override
  void initState() {
    super.initState();
    switchValue = widget.value ?? false;
    widget.onChanged?.call(switchValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 8),
        Text(widget.labelText ?? ""),
        Container(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value ?? false;
                    widget.onChanged?.call(value ?? false);
                  });
                }),
            Text(switchValue ? widget.activeText ?? "" : widget.inactiveText ?? ""),
          ],
        ),
        Container(height: 4),
      ],
    );
  }
}
