import 'package:flutter/material.dart';

class SwitchForm extends StatefulWidget {
  SwitchForm({
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
  _SwitchFormState createState() => _SwitchFormState();
}

class _SwitchFormState extends State<SwitchForm> {
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
        Container(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    widget.onChanged?.call(value);
                  });
                }),
            Text(switchValue ? widget.activeText ?? "" : widget.inactiveText ?? ""),
          ],
        ),
      ],
    );
  }
}
