import 'package:ak_azm_flutter/app/view/preferences/preferences_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../module/common/extension.dart';
import '../../module/res/colors.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../widget_utils/base_scaffold.dart';
import '../widget_utils/buttons/filled_button.dart';
import '../widget_utils/network_avatar_picker.dart';

class PreferencesPage extends PageProvideNode<PreferencesViewModel> {
  PreferencesPage({Key? key}) : super(key: key, params: []);

  @override
  Widget buildContent(BuildContext context) {
    return PreferencesContent(viewModel);
  }
}

class PreferencesContent extends StatefulWidget {
  PreferencesViewModel _preferencesViewModel;

  PreferencesContent(this._preferencesViewModel);

  @override
  State<PreferencesContent> createState() => _PreferencesContentState();
}

class _PreferencesContentState extends State<PreferencesContent> {
  PreferencesViewModel get preferencesViewModel => widget._preferencesViewModel;

  @override
  void initState() {
    super.initState();
    preferencesViewModel.initAvatar();
    preferencesViewModel.getLanguagesApi();
    preferencesViewModel.getSettingsApi();
  }

  @override
  Widget build(BuildContext context) {
    //appbar
    return BaseScaffold(
      transparentStatusBar: 0.0,
      backgroundColor: kColorBackground,
      title: LocaleKeys.change_my_preferences.tr(),
      hideBackButton: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: size_10_w,
                          right: size_10_w,
                        ),
                        child: Consumer<PreferencesViewModel>(
                          builder: (context, value, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //avatar
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size_22_w, bottom: size_20_w),
                                      child: Container(
                                        width: size_80_w,
                                        height: size_80_w,
                                        child: Consumer<PreferencesViewModel>(
                                            builder: (context, value, child) {
                                              return NetworkAvatarPicker(
                                                onGetPhotoFromGalleryPressed:
                                                value.pickImage,
                                                onGetPhotoFromCameraPressed:
                                                value.takePhoto,
                                                imageUrl: value.imagePath,
                                                imageByteWidget: Utils.imageFromByte(value.imageByte ?? null, size_80_w, size_80_w),
                                                width: size_80_w,
                                                height: size_80_w,
                                              );
                                            }),
                                      ),
                                    ),
                                    SizedBox(width: size_14_w,),
                                    //name
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: size_20_w),
                                        child: Material(
                                          color: kWhite,
                                          borderRadius:
                                          BorderRadius.circular(size_5_r),
                                          child: TextField(
                                            enabled: false,
                                            style: TextStyle(
                                              color: kCBlack,
                                              fontSize: text_25,
                                            ),
                                            textAlignVertical:
                                            TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(size_5_r),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(size_5_r),
                                                borderSide: BorderSide(
                                                  color: kCBlack,
                                                  width: size_1_w,
                                                ),
                                              ),
                                              labelText:
                                              value.settingsResult?.displayName ??
                                                  '',
                                              labelStyle: TextStyle(
                                                fontSize: text_20,
                                                color: kCBlack,
                                              ),
                                              hintText: LocaleKeys.pos_name.tr(),
                                              hintStyle: TextStyle(
                                                fontSize: text_20,
                                                color: kCBlack,
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: size_10_w,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                ),


                                //notification
                                Text(
                                  LocaleKeys.notification.tr(),
                                  style: TextStyle(fontSize: text_14),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size_6_w,
                                    bottom: size_14_w,
                                  ),
                                  child: Consumer<PreferencesViewModel>(
                                    builder: (context, value, child) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                            fillColor: kCWhite,
                                            filled: true,
                                            hintStyle: TextStyle(
                                                fontSize: size_20_w,
                                                color: kCBlack),
                                            contentPadding: EdgeInsets.all(
                                              size_10_w,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size_5_r),
                                              borderSide: BorderSide(
                                                color: kCOrange,
                                                width: size_1_w,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size_5_r))),
                                        isEmpty: value.notifyValue == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: value.notifyValue,
                                            icon: Icon(Icons.keyboard_arrow_down_sharp),
                                            isExpanded: true,
                                            isDense: true,
                                            onChanged: (val) {
                                              value.changeNotification(val);
                                            },
                                            items: [
                                              DropdownMenuItem(
                                                  value: 'email',
                                                  child: Text(
                                                      LocaleKeys
                                                          .handle_by_emails
                                                          .tr(),
                                                      style: TextStyle(
                                                          fontSize: text_14,
                                                          color: kCBlack))),
                                              DropdownMenuItem(
                                                  value: 'inbox',
                                                  child: Text(
                                                      LocaleKeys.handle_in_odoo
                                                          .tr(),
                                                      style: TextStyle(
                                                          fontSize: text_14,
                                                          color: kCBlack))),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                //Language
                                Text(
                                  LocaleKeys.language.tr(),
                                  style: TextStyle(fontSize: text_14),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size_6_w,
                                    bottom: size_14_w,
                                  ),
                                  child: Consumer<PreferencesViewModel>(
                                    builder: (context, value, child) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                            fillColor: kCWhite,
                                            filled: true,
                                            contentPadding: EdgeInsets.all(
                                              size_10_w,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(size_5_r),
                                              borderSide: BorderSide(
                                                color: kCOrange,
                                                width: size_1_w,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(size_5_r))),
                                        isEmpty: value.languageValue == '',
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: value.languageValue,
                                            icon: Icon(Icons.keyboard_arrow_down_sharp),
                                            isDense: true,
                                            underline: SizedBox(),
                                            onChanged: (val) {
                                              value.changeLanguage(val);
                                            },
                                            items: value.selectionLang.map<DropdownMenuItem<String>>(
                                                    (element) => DropdownMenuItem<String>(
                                                  value: element.code,
                                                  child: Text(
                                                      element.name ?? '',
                                                      style: TextStyle(
                                                        fontSize: text_14,
                                                        color: kCBlack,
                                                      )),
                                                ))
                                                .toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                //email
                                Text(
                                  LocaleKeys.email.tr(),
                                  style: TextStyle(fontSize: text_14),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: size_6_w,
                                  ),
                                  child: Material(
                                    color: kWhite,
                                    borderRadius:
                                        BorderRadius.circular(size_5_r),
                                    child: TextField(
                                      controller: value.emailController,
                                      style: TextStyle(
                                        color: kCBlack,
                                        fontSize: text_14,
                                      ),
                                      onChanged: (val) =>
                                          value.onChangeEmail(val),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(size_5_r),
                                          borderSide: BorderSide(
                                            color: kCBlack,
                                            width: size_1_w,
                                          ),
                                        ),
                                        hintText: LocaleKeys.email.tr(),
                                        hintStyle: TextStyle(
                                          fontSize: text_14,
                                          color: kCBlack,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(size_5_r),
                                          borderSide: BorderSide(
                                            color: kCBlack,
                                            width: size_1_w,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(
                                          size_10_w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Button goto sign in
            Positioned(
              bottom: size_30_w,
              left: size_26_w,
              right: size_26_w,
              child: Consumer<PreferencesViewModel>(
                builder: (context, value, child) {
                  return FilledButton(
                    enable: value.validate,
                    text: LocaleKeys.save.tr().toUpperCase(),
                    onPress: () => preferencesViewModel.saveSettings(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
