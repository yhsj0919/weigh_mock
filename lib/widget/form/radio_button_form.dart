import 'package:flutter/material.dart';

class RadioItem {
  RadioItem({this.id, this.name, this.tooltip});

  String? id;
  String? name;
  String? tooltip;
}

class RadioButtonForm extends StatefulWidget {
  const RadioButtonForm({
    Key? key,
    this.labelText,
    this.onChanged,
    this.value,
    required this.items,
  })  : assert(items.length > 0, "items length必须大于0"),
        super(key: key);
  final String? labelText;
  final RadioItem? value;
  final List<RadioItem> items;
  final ValueChanged<RadioItem>? onChanged;

  @override
  _RadioButtonFormState createState() => _RadioButtonFormState();
}

class _RadioButtonFormState extends State<RadioButtonForm> {
  late String switchValue;

  @override
  void initState() {
    super.initState();
    if (widget.value != null && widget.value?.id != null && widget.value?.id != "" && widget.value?.id != "null") {
      switchValue = widget.value!.id!;
      widget.onChanged?.call(widget.value ?? widget.items[0]);
    } else {
      switchValue = widget.items[0].id ?? "";
      widget.onChanged?.call(widget.items[0]);
    }
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
        Wrap(
          // mainAxisSize: MainAxisSize.min,
          children: widget.items
              .map((e) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                          value: e.id ?? "",
                          groupValue: switchValue,
                          onChanged: (value) {
                            setState(() {
                              switchValue = value!;
                              widget.onChanged?.call(e);
                            });
                          }),
                      Tooltip(
                        message: e.tooltip ?? "",
                        child: Text(e.name ?? ""),
                      ),
                      Container(width: 4)
                    ],
                  ))
              .toList(),
        ),
        Container(height: 4),
      ],
    );
  }
}
