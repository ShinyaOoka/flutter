import 'package:flutter/material.dart';
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
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime.now(),
            );
            onChanged?.call(date);
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
