import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final ScrollController? scrollController;
  final bool? enabled;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onEditingComplete;
  final String? hintText;
  final String? counterText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Color? counterColor;
  final bool readOnly;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          style: TextStyle(color: Theme.of(context).primaryColor),
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: label != null ? Text(label!) : null,
              border: const OutlineInputBorder(),
              fillColor: fillColor,
              hintText: hintText,
              counterText: _counterText,
              counterStyle:
                  TextStyle(height: 0.2, color: counterColor, fontSize: 10)),
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          scrollController: scrollController,
        ),
        const SizedBox(height: 6)
      ],
    );
  }

  String? get _counterText {
    if (counterText != null) {
      return counterText;
    }

    if (maxLength != null) {
      return null;
    }

    return ' ';
  }

  const AppTextField({
    super.key,
    this.label,
    this.controller,
    this.enabled,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.onEditingComplete,
    this.hintText,
    this.counterText,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.counterColor,
    this.fillColor,
    this.readOnly = false,
    this.scrollController,
  });
}
