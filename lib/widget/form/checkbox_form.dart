import 'package:flutter/material.dart';

class CheckBoxItem {
  CheckBoxItem({this.id, this.name, this.tooltip});

  String? id;
  String? name;
  bool? checked;
  String? tooltip;
}

class CheckBoxForm extends StatefulWidget {
  const CheckBoxForm({
    Key? key,
    this.labelText,
    this.onChanged,
    this.value,
    required this.items,
  })  : assert(items.length > 0, "items length必须大于0"),
        super(key: key);
  final String? labelText;
  final List<CheckBoxItem>? value;
  final List<CheckBoxItem> items;
  final ValueChanged<List<CheckBoxItem>>? onChanged;

  @override
  _CheckBoxFormState createState() => _CheckBoxFormState();
}

class _CheckBoxFormState extends State<CheckBoxForm> {
  final List<String> switchValue = [];

  @override
  void initState() {
    super.initState();
    if (widget.value != null && widget.value?.isNotEmpty == true) {
      switchValue.clear();

      switchValue.addAll(widget.value!.map((e) => e.id!).toList());

      widget.onChanged?.call(widget.value ?? []);
    } else {
      switchValue.clear();
      widget.onChanged?.call([]);
    }
  }

  @override
  void didUpdateWidget(covariant CheckBoxForm oldWidget) {
    if (oldWidget.value != widget.value) {
      switchValue.clear();
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        widget.onChanged?.call([]);
      });
    }

    super.didUpdateWidget(oldWidget);
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
                      Checkbox(
                          value: switchValue.contains(e.id),
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                switchValue.add(e.id ?? "");
                              } else {
                                switchValue.remove(e.id ?? "");
                              }
                              widget.onChanged?.call(widget.items.where((element) => switchValue.contains(element.id)).toList());
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
