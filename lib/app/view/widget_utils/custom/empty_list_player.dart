import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../module/res/colors.dart';
import '../../../module/res/string.dart';
import '../../../module/res/text.dart';

Widget EmptyListPlayer() {
  return SafeArea(
    child: Center(
      child: Text(
        '',
        style: TextStyle(
            color: kWhite,
            fontSize: text_16,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal),
        )
    ),
  );
}
