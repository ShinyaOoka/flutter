import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import 'anims/touchable_opacity.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    Key? key,
    required this.onGetPhotoFromGalleryPressed,
    required this.onGetPhotoFromCameraPressed,
    this.imageByte,
  }) : super(key: key);

  final Function() onGetPhotoFromGalleryPressed;
  final Function() onGetPhotoFromCameraPressed;
  final Uint8List? imageByte;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onPressed: () {
        final textStyle = TextStyle(
          color: kColor007bff,
          fontSize: text_20,
        );

        showAdaptiveActionSheet(
          context: context,
          actions: [
            BottomSheetAction(
              title: Text(
                LocaleKeys.user_profile_btn_from_photo_library.tr(),
                style: textStyle,
              ),
              onPressed: onGetPhotoFromGalleryPressed.call(),
            ),
            BottomSheetAction(
              title: Text(
                LocaleKeys.user_profile_btn_take_a_photo.tr(),
                style: textStyle,
              ),
              onPressed: onGetPhotoFromCameraPressed.call(),
            )
          ],
          cancelAction: CancelAction(
            title: Text(
              LocaleKeys.user_profile_btn_cancel.tr(),
              style: textStyle,
            ),
          ),
        );
      },
      child: imageByte == null
          ? Image.asset(
              'assets/images/ig_add_user_photo.webp'
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(300.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.memory(
                    imageByte!,
                    fit: BoxFit.cover,
                    width: size_250_h,
                    height: size_250_h,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: size_50_h,
                      height: size_50_h,
                      color: kCTransparent60,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
