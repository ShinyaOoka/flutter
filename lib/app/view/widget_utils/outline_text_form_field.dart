import 'package:ak_azm_flutter/app/view/widget_utils/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../module/res/colors.dart';
import '../../module/res/dimens.dart';
import '../../module/res/style.dart';

class OutlineTextFormField extends StatefulWidget {
  final String? hintText;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;

  List<TextInputFormatter>? inputformatter;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool readOnly;
  final String? Function(String?)? validator;
  final bool? isShowLable;
  final Color? colorBorder;
  final Color? colorFocusBorder;
  final Color? colorDisableBorder;
  final Color? colorBackground;
  final Color? labelBackgroundColor;
  final Widget? widgetSuffix;
  final BorderRadius? borderRadius;
  final int? maxLength;
  final Color? textColor;
  final Widget? counterWidget;
  final TextStyle? counterStyle;
  final bool isAlwaysShowLable;
  final String? labelText;
  final TextAlign? textAlign;
  final String? counterText;

  OutlineTextFormField(
      {Key? key,
      this.hintText,
      this.obscureText = false,
      this.enabled = true,
      this.controller,
      this.onChanged,
      this.onFieldSubmitted,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.focusNode,
      this.nextFocusNode,
      this.readOnly = false,
      this.validator,
      this.isShowLable,
      this.colorBorder,
      this.colorDisableBorder,
      this.colorFocusBorder,
      this.colorBackground,
      this.widgetSuffix,
      this.inputformatter,
      this.borderRadius,
      this.maxLength,
      this.textColor,
      this.counterWidget,
      this.counterStyle,
      this.isAlwaysShowLable = false,
      this.labelText,
      this.labelBackgroundColor,
      this.textAlign,
      this.onTap,
      this.counterText})
      : super(key: key);

  @override
  _OutlineTextFormFieldState createState() => _OutlineTextFormFieldState();
}

class _OutlineTextFormFieldState extends State<OutlineTextFormField> {
  var isShowPassword = false;
  var hasError = false;

  @override
  void initState() {
    isShowPassword = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hintTextStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        fontWeight: FontWeight.normal, color: Colors.black.withOpacity(0.6));
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.normal,
        );
    return Stack(
      children: [
        Container(
            alignment: Alignment.center,
            color: widget.colorBackground ?? Colors.transparent,
            child: TextFormField(
              minLines:
                  widget.maxLength != null && widget.maxLength! >= 100 ? 3 : 1,
              maxLines:
                  widget.maxLength != null && widget.maxLength! >= 100 ? 3 : 1,
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: widget.inputformatter,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                floatingLabelBehavior: widget.isAlwaysShowLable
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.auto,
                counter: widget.counterWidget,
                counterText: widget.counterText,
                counterStyle: widget.counterStyle?.copyWith(height: 0.5),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: kColorCED4DA),
                labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    backgroundColor: widget.labelBackgroundColor ??
                        widget.labelBackgroundColor),
                labelText: widget.labelText,
                border: OutlineInputBorder(
                  borderRadius: widget.borderRadius ??
                      const BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(color: kColorCED4DA, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius ??
                      const BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(
                      color: widget.colorFocusBorder ?? kColorPrimary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius ??
                      const BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(
                      color: widget.colorBorder ?? kColorCED4DA, width: 1.5),
                ),
                isDense: true,
                suffixIcon: widget.widgetSuffix ??
                    (widget.obscureText == true
                        ? TouchableOpacity(
                            onPressed: () {
                              setState(() {
                                isShowPassword = !isShowPassword;
                              });
                            },
                            child: SvgPicture.asset(
                              isShowPassword ? '' : '',
                              width: size_22_w,
                              height: size_22_w,
                              color: kColor89000000,
                            ),
                          )
                        : null),
                disabledBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius ??
                      const BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(
                      color: widget.colorDisableBorder ?? kColorCED4DA),
                ),
              ),
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText ? isShowPassword : false,
              style: TextStyle(color: widget.textColor, fontSize: 20),
              enabled: widget.enabled,
              controller: widget.controller,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {});

                widget.onChanged?.call(value);
              },
              onTap: widget.onTap,
              onFieldSubmitted: (value) {
                if (widget.textInputAction == TextInputAction.next) {
                  widget.nextFocusNode?.requestFocus();
                }
                widget.onFieldSubmitted?.call(value);
              },
              textInputAction: widget.textInputAction,
              focusNode: widget.focusNode,
              readOnly: widget.readOnly,
              validator: (value) {
                final errorText = widget.validator?.call(value);
                hasError = errorText == null;
                return errorText;
              },
              textAlign: widget.textAlign ?? TextAlign.start,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            )),
      ],
    );
  }
}
