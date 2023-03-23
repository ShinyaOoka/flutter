import 'package:ak_azm_flutter/widgets/report/optional_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AppTimePicker extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final void Function(TimeOfDay?)? onChanged;
  final String? hintText;
  final TimeOfDay? selectedTime;
  final bool readOnly;
  final Color? fillColor;
  final TimeOfDay? defaultTime;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          style: TextStyle(color: Theme.of(context).primaryColor),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: label != null
                ? optional
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label!),
                          const SizedBox(width: 8),
                          OptionalBadge(),
                        ],
                      )
                    : Text(label!)
                : null,
            border: OutlineInputBorder(
                borderSide: readOnly ? BorderSide.none : BorderSide()),
            hintText: hintText,
            counterText: " ",
            counterStyle: const TextStyle(height: 0.2, fontSize: 10),
            fillColor: fillColor ?? Colors.white,
            suffixIcon: !readOnly && selectedTime != null
                ? IconButton(
                    onPressed: () => onChanged?.call(null),
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          controller: controller ??
              TextEditingController(
                  text: selectedTime != null
                      ? '${selectedTime!.hour}時${selectedTime!.minute}分'
                      : null),
          readOnly: true,
          onTap: () async {
            if (readOnly) return;
            final now = DateTime.now();
            DatePicker.showTimePicker(
              context,
              showTitleActions: true,
              locale: LocaleType.jp,
              onConfirm: (date) =>
                  onChanged?.call(TimeOfDay.fromDateTime(date)),
              currentTime: selectedTime != null
                  ? DateTime(now.year, now.month, now.day, selectedTime!.hour,
                      selectedTime!.minute)
                  : defaultTime != null
                      ? DateTime(now.year, now.month, now.day,
                          defaultTime!.hour, defaultTime!.minute)
                      : DateTime.now(),
              showSecondsColumn: false,
            );
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
    this.readOnly = false,
    this.fillColor,
    this.defaultTime,
    this.optional = false,
  });
}
