import 'package:ak_azm_flutter/app/module/res/dimens.dart';
import 'package:ak_azm_flutter/app/module/res/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../anims/animated_in_widget.dart';


class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.onBoardingTitle,
    required this.onBoardingDescription,
  }) : super(key: key);

  final String onBoardingTitle;
  final String onBoardingDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size_24_h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedInWidget(
            order: 1,
            child: Text(
              onBoardingTitle,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: text_20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: size_18_h,
          ),
          AnimatedInWidget(
            order: 2,
            child: Text(
              onBoardingDescription,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: text_14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}