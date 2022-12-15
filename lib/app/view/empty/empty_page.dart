import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../module/res/style.dart';

class EmptyWidget extends StatelessWidget {
  String? imgEmpty;
  String? emptyText;
  RefreshCallback? onRefresh;

  EmptyWidget({Key? key, this.emptyText, this.imgEmpty, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: size_100_w),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imgEmpty ?? '',
                width: size_160_w,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: size_20_w,
              ),
              Text(
                emptyText ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: text_14,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return onRefresh == null
        ? content
        : RefreshIndicator(
            color: kColorPrimary,
            onRefresh: onRefresh!,
            child: content,
          );
  }
}
