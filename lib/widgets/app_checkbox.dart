import 'package:ak_azm_flutter/widgets/report/optional_badge.dart';
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final String? label;
  final bool? value;
  final void Function(bool?)? onChanged;
  final bool? readOnly;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IgnorePointer(
        ignoring: readOnly == true,
        child: ListTileTheme(
          horizontalTitleGap: 4,
          child: CheckboxListTile(
            title: label != null
                ? Text(label!, style: TextStyle(fontSize: 16))
                : null,
            value: value ?? false,
            onChanged: onChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            dense: dense,
          ),
        ),
      ),
      const SizedBox(height: 14)
    ]);
  }

  const AppCheckbox({
    super.key,
    this.label,
    this.value,
    this.onChanged,
    this.readOnly,
    this.dense = false,
  });
}
