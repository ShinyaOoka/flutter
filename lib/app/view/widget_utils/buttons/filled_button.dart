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

  const FilledButton({
    Key? key,
    this.onPress,
    required this.text,
    this.color,
    this.textStyle,
    this.enable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !enable ? null : onPress,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size_8_r),
          color: !enable ? kColorPrimaryDisable : color ?? kColorPrimary,
        ),
        child: Container(
          height: size_46_h,
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
