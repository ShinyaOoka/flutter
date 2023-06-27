import 'package:ak_azm_flutter/widgets/report/optional_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
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
  final bool optional;

  @override
  State<AppTextField> createState() => _AppTextFieldState();

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
    this.optional = false,
  });
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  void dispose() {
    if (widget.controller?.text != null && widget.maxLength != null) {
      widget.onChanged?.call(
          widget.controller!.text.characters.take(widget.maxLength!).string);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          onFocusChange: (focus) {
            if (focus) return;
            if (widget.controller?.text != null && widget.maxLength != null) {
              widget.onChanged?.call(widget.controller!.text.characters
                  .take(widget.maxLength!)
                  .string);
            }
          },
          child: TextFormField(
            style: TextStyle(color: Theme.of(context).primaryColor),
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: widget.label != null
                    ? widget.optional
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.label!),
                              const SizedBox(width: 8),
                              const OptionalBadge(),
                            ],
                          )
                        : Text(widget.label!)
                    : null,
                border: OutlineInputBorder(
                    borderSide:
                        widget.readOnly ? BorderSide.none : const BorderSide()),
                fillColor: widget.fillColor ??
                    (widget.readOnly ? const Color(0xFFF5F5F5) : Colors.white),
                hintText: widget.hintText,
                counterText: _counterText,
                counterStyle: TextStyle(
                    height: 0.2, color: widget.counterColor, fontSize: 10)),
            controller: widget.controller,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            inputFormatters: widget.inputFormatters,
            readOnly: widget.readOnly,
            scrollController: widget.scrollController,
          ),
        ),
        const SizedBox(height: 6)
      ],
    );
  }

  String? get _counterText {
    if (widget.counterText != null) {
      return widget.counterText;
    }

    if (widget.maxLength != null) {
      return null;
    }

    return ' ';
  }
}
