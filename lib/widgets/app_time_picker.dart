import 'package:flutter/material.dart';

class AppTimePicker extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final void Function(TimeOfDay?)? onChanged;
  final String? hintText;
  final TimeOfDay? selectedTime;
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
                  text: selectedTime != null
                      ? '${selectedTime!.hour}時${selectedTime!.minute}分'
                      : null),
          readOnly: true,
          onTap: () async {
            final date = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            onChanged?.call(date);
          },
        ),
        const SizedBox(height: 6)
      ],
    );
  }

  const AppTimePicker({
    super.key,
    this.label,
    this.onChanged,
    this.hintText,
    this.controller,
    this.selectedTime,
  });
}
