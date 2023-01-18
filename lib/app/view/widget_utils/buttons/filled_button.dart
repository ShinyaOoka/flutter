import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../module/res/colors.dart';
import '../../../module/res/dimens.dart';

class FilledButton extends StatelessWidget {
  final Function()? onPress;
  final String text;
  final Color? color;
  final TextStyle? textStyle;
  final bool enable;
  final double? borderRadius;

  const FilledButton({
    Key? key,
    this.onPress,
    required this.text,
    this.color,
    this.textStyle,
    this.enable = true,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !enable ? null : onPress,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? size_8_r),
          color: !enable ? kColorPrimaryDisable : color ?? kColorPrimary,
        ),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            text,
            style: textStyle ??
                (Theme.of(context).textTheme.button ?? TextStyle()).copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
