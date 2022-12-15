
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../di/injection.dart';
import '../../../module/common/navigator_screen.dart';
import '../../../module/res/colors.dart';
import '../../../module/res/dimens.dart';
import '../../../module/res/text.dart';

void showGeneralDialog({String? message}) {
  BuildContext context = getIt<NavigationService>().navigatorKey.currentContext!;
  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return GeneralDialog(
          message: message,
          defaultAction: () {
            Navigator.pop(context);
          },
        );
      });
}

class GeneralDialog extends StatelessWidget {
   String? message;
   String? actionString;
  VoidCallback? defaultAction;

  GeneralDialog(
      {Key? key,
      this.message = '',
      this.actionString = '',
      this.defaultAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size_10_r),
      ),
      elevation: 0,
      insetPadding: EdgeInsets.all(30.0),
      backgroundColor: Colors.white,
      child: Wrap(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size_10_r),
            ),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size_20_h,
                      horizontal: size_20_w,
                    ),
                    child: Text(
                      message?? "",
                      textAlign: TextAlign.center,
                      style: kTSSVNGilroy.copyWith(
                        color: Colors.black,
                        fontSize: text_16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: kColorD3DDE9,
                  height: 1,
                ),
                BouncingWidget(
                  duration: Duration(milliseconds: 100),
                  scaleFactor: 1.0,
                  onPressed: () {
                    defaultAction?.call();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(size_10_r),
                          bottomRight: Radius.circular(size_10_r)),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size_14_h),
                      child: Center(
                        child: Text(
                          actionString!,
                          style: kTSSVNGilroy.copyWith(
                              color: kColor247EF1,
                              fontSize: text_18,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
