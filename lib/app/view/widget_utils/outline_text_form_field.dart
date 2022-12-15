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
  final Widget? widgetSuffix;
  final BorderRadius? borderRadius;
  final int? maxLength;
  final Color? textColor;
  final Widget? counterWidget;
  final TextStyle? counterStyle;
  final bool isAlwaysShowLable;
  final String? labelText;

  OutlineTextFormField({
    Key? key,
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
    this.labelText
  }) : super(key: key);

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
        fontSize: text_16,
        fontWeight: FontWeight.normal,
        color: Colors.black.withOpacity(0.6));
    final textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
          fontSize: text_16,
          fontWeight: FontWeight.normal,
        );
    return Stack(
      children: [
        Container(
            alignment: Alignment.center,
            color: widget.colorBackground ?? Colors.transparent,
            child: TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              inputFormatters: widget.inputformatter,
              maxLength: widget.maxLength ?? TextField.noMaxLength ,
              decoration: InputDecoration(
                floatingLabelBehavior: widget.isAlwaysShowLable ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
                counter: widget.counterWidget,
                counterStyle: widget.counterStyle,
                hintText: widget.hintText,
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                labelText: widget.labelText,
                border: OutlineInputBorder(
                  borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
                  borderSide:
                      BorderSide(color: widget.colorBorder ?? kColorCED4DA),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(
                      color: widget.colorFocusBorder ?? kColorPrimary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
                  borderSide:
                      BorderSide(color: widget.colorBorder ?? kColorCED4DA),
                ),
                hintStyle: hintTextStyle,
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
                              isShowPassword
                                  ? 'assets/icons/ic_eye.svg'
                                  : 'assets/icons/ic_eye_off.svg',
                              width: size_22_w,
                              height: size_22_w,
                              color: kColor89000000,
                            ),
                          )
                        : null),
                contentPadding: EdgeInsets.symmetric(
                  vertical: size_14_h,
                  horizontal: size_10_w,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(
                      color: widget.colorDisableBorder ?? kColorCED4DA),
                ),
              ),
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText ? isShowPassword : false,
              style: widget.textColor != null ? textStyle?.copyWith(color: widget.textColor) : textStyle,
              enabled: widget.enabled,
              controller: widget.controller,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {});

                widget.onChanged?.call(value);
              },
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

              autovalidateMode: AutovalidateMode.onUserInteraction,
            )),
      ],
    );
  }
}
