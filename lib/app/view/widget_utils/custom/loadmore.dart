
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../module/res/colors.dart';
import '../../../module/res/dimens.dart';

class BuildLoadMore extends StatelessWidget {
  const BuildLoadMore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: size_14_h, top: size_14_h),
      child: Center(
        child: Container(
          width: size_22_w,
          height: size_22_w,
          child: CircularProgressIndicator(
            strokeWidth: 2.8,
            valueColor: AlwaysStoppedAnimation<Color>(kColor247EF1),
          ),
        ),
      ),
    );

    ;
  }
}
