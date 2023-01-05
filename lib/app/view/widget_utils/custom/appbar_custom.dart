
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../module/res/dimens.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final Color? colorBackGround;
  final String? resIcon;
  late double iconSize = size_20_w;
  final VoidCallback? onPressIcon;
  final Widget? widgetTitle;
  final Alignment? alignmentTitle;

  AppBarCustom({
    Key? key,
    this.resIcon,
    this.onPressIcon,
    this.widgetTitle,
    this.alignmentTitle = Alignment.center,
    this.colorBackGround,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: colorBackGround ?? Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          right: size_16_w,
        ),
        child: Center(child: _buildWidgetTitle()),
      ),
    );
  }

  Widget _buildIconLeading() {
    return resIcon == null || resIcon!.isEmpty
        ? Container()
        : InkWell(
          child: Ink(
            height: kToolbarHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size_16_w),
              child: SvgPicture.asset(
                '',
                width: size_20_w,
                height: size_20_w,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () => onPressIcon?.call(),
        );
  }

  Widget _buildWidgetTitle() {
    /*if (alignmentTitle == null)
      throw Exception('Must add params \'alignmentTitle\' in appbar custom');*/
    return alignmentTitle == Alignment.center
        ? Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size_16_w * 2 + iconSize,
                ),
                child: Center(
                  child: widgetTitle,
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft, child: _buildIconLeading()),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildIconLeading(),
              Expanded(
                child: Container(
                  alignment: alignmentTitle,
                  child: widgetTitle,
                ),
              ),
            ],
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
