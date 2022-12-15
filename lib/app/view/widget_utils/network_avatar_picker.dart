import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import 'adaptive_url_image.dart';
import 'anims/touchable_opacity.dart';
import 'custom/image_holder.dart';

class NetworkAvatarPicker extends StatelessWidget {
  const NetworkAvatarPicker({
    Key? key,
    required this.onGetPhotoFromGalleryPressed,
    required this.onGetPhotoFromCameraPressed,
    this.imageUrl,
    this.width,
    this.height, this.imageByteWidget,
  }) : super(key: key);

  final Function() onGetPhotoFromGalleryPressed;
  final Function() onGetPhotoFromCameraPressed;
  final String? imageUrl;
  final double? width;
  final double? height;
  final Widget? imageByteWidget;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onPressed: () {
        final textStyle = TextStyle(
            color: kColor007bff,
            fontSize: text_14,
            fontWeight: FontWeight.normal);

        showAdaptiveActionSheet(
          context: context,
          actions: [
            BottomSheetAction(
              title: Text(
                LocaleKeys.user_profile_btn_from_photo_library.tr(),
                style: textStyle,
              ),
              onPressed: (context) => onGetPhotoFromGalleryPressed.call(),
            ),
            BottomSheetAction(
              title: Text(
                LocaleKeys.user_profile_btn_take_a_photo.tr(),
                style: textStyle,
              ),
              onPressed: (context) => onGetPhotoFromCameraPressed.call(),
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
      child:

      ClipOval(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  imageUrl == null || imageUrl!.isEmpty ? imageByteWidget!
                  /*Image.memory(
                    imageByte!,
                    fit: BoxFit.cover,
                    height: height,
                    width: width,
                  )*/ :
                  imageUrl!.startsWith("http") || imageUrl!.startsWith("https")
                      ? Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: kCWhite.withOpacity(0.9),
                            // border color
                            shape: BoxShape.rectangle,
                          ),
                          child: TouchableOpacity(
                            onPressed: () {},
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/placeholder.jpg',
                              image: imageUrl ?? '',
                              fit: BoxFit.fitHeight,
                              width: width,
                              height: height,
                              fadeInDuration: Duration(milliseconds: 50),
                              //ERROR IMAGE WHEN LOAD IMAGE
                              imageErrorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return ImageHolder(
                                  asset: 'assets/images/placeholder.jpg',
                                  width: width,
                                  height: height,
                                );
                              },
                            ),
                          ),
                        )
                      : AdaptiveUrlImage(
                          url: imageUrl ?? '',
                          height: height,
                          width: width,
                          fit: BoxFit.cover,
                        ),
                  Image.asset(
                    'assets/images/ig_grey_bg.webp',
                    height: size_30_w,
                    fit: BoxFit.fitHeight,
                  ),
                  Positioned(
                    bottom: size_10_w,
                    child: Image.asset(
                      'assets/images/ic_camera.webp',
                      width: size_16_w,
                      height: size_16_w,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
