import 'package:ak_azm_flutter/app/view/widget_utils/anims/touchable_opacity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../model/login_config.dart';
import '../../module/res/style.dart';
import '../widget_utils/avatar_profile_circle.dart';

class ItemAccount extends StatelessWidget {
  LoginConfig loginConfig;
  VoidCallback onClickItem;
  VoidCallback onDeleteItem;

  ItemAccount({
    Key? key,
    required this.loginConfig,
    required this.onClickItem,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(left: size_8_w, right: size_8_w, top: size_8_w),
      color: Colors.white,
      child: Ink(
        child: InkWell(
          onTap: () => onClickItem.call(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size_8_r),
              border: Border.all(
                width: size_1_w,
                color: kColorDEE2E6,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: size_10_w),
            child: Container(
              margin: EdgeInsets.only(left: size_10_w),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TouchableOpacity(
                    onPressed: () {},
                    child: AvatarProfileCircle(
                      avatarUrl: loginConfig.avatarUrl,
                      size: size_50_w,
                    ),
                  ),
                  SizedBox(
                    width: size_10_w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          loginConfig.userName ?? '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black,
                              fontSize: text_14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size_3_w,
                        ),
                        Text(
                          LocaleKeys.email_info.tr(
                              namedArgs: {'email': loginConfig.email ?? ''}),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black54,
                              fontSize: text_12,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: size_3_w,
                        ),
                        Text(
                          LocaleKeys.server_info.tr(namedArgs: {
                            'server': loginConfig.getBaseUrl(),
                          }),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black54,
                              fontSize: text_12,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: size_3_w,
                        ),
                        Text(
                          LocaleKeys.database_info.tr(namedArgs: {
                            'database': loginConfig.database ?? '',
                          }),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.black54,
                              fontSize: text_12,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size_10_w,
                  ),
                  Container(
                    height: size_26_w,
                    child: TouchableOpacity(
                      onPressed: () => onDeleteItem.call(),
                      child: Container(
                        width: size_26_w,
                        height: size_26_w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black26),
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: size_18_w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
