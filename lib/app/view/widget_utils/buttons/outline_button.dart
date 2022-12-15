import 'package:flutter/material.dart';

import '../../../module/res/dimens.dart';
import '../../../module/res/text.dart';

class OutlineButton extends StatelessWidget {
  final Function()? onPress;
  final String text;
  final TextStyle? textStyle;
  final Color color;
  final bool reversed;

  const OutlineButton({
    Key? key,
    this.onPress,
    required this.text,
    this.textStyle,
    required this.color,
    this.reversed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        constraints: BoxConstraints(
          minWidth: size_64_h,
          minHeight: size_46_h,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: size_6_w,
          vertical: size_8_h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size_8_r),
          border: Border.all(
            color: reversed ? color : Colors.transparent,
          ),
          color: reversed ? Colors.transparent : color,
        ),
        child: Text(
          text,
          style: textStyle ??
              (Theme.of(context).textTheme.button ?? TextStyle()).copyWith(
                fontSize: text_14,
                color: reversed ? color : Colors.white,
              ),
        ),
      ),
    );
  }
}
