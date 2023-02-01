import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AppDatePicker extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final void Function(DateTime?)? onChanged;
  final String? hintText;
  final DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          style: TextStyle(color: Theme.of(context).primaryColor),
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: label != null ? Text(label!) : null,
              border: const OutlineInputBorder(),
              hintText: hintText,
              counterText: " ",
              counterStyle: const TextStyle(height: 0.4, fontSize: 10)),
          controller: controller ??
              TextEditingController(
                  text: selectedDate != null
                      ? DateFormat.yMMMMd('ja_JP').format(selectedDate!)
                      : null),
          readOnly: true,
          onTap: () async {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              locale: LocaleType.jp,
              onConfirm: (date) => onChanged?.call(date),
              currentTime: selectedDate ?? DateTime.now(),
            );
          },
        ),
        const SizedBox(height: 6)
      ],
    );
  }

  const AppDatePicker({
    super.key,
    this.label,
    this.onChanged,
    this.hintText,
    this.controller,
    this.selectedDate,
  });
}
