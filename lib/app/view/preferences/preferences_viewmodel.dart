import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ak_azm_flutter/app/model/customer_add_country.dart';
import 'package:ak_azm_flutter/app/module/common/toast_util.dart';
import 'package:ak_azm_flutter/app/module/network/response/base_response.dart';
import 'package:ak_azm_flutter/app/module/network/response/loadviews_response.dart';
import 'package:ak_azm_flutter/app/module/network/response/settings_response.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/flutter_easyloading/src/easy_loading.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../../model/session_info.dart';
import '../../module/common/config.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/permission_utils.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/response/languages_response.dart';
import '../../module/network/response/save_settings_response.dart';
import '../../module/network/response/shops_response.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class PreferencesViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  SettingsResult? settingsResult;
  String? notifyValue = 'email';
  String? languageValue = 'en_GB';
  String email = '';
  var emailController = TextEditingController();
  Uint8List? imageByte;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();
  List<Language> selectionLang = [];

  final Countrys = [
    Country(
      name: 'None',
    ),
    Country(
      name: 'Afghanistan',
    ),
    Country(
      name: 'Albania',
    ),
    Country(
      name: 'Algeria',
    ),
  ];

  PreferencesViewModel(this._dataRepo);

  String? invalidEmail(String? value) {
    return value?.isEmpty == true || !Utils.isEmail(value!.trim())
        ? LocaleKeys.invalid_email.tr()
        : null;
  }

  bool get validate => Utils.isEmail(email.trim()) && email.isNotEmpty;

  changeNotification(dynamic value) {
    this.notifyValue = value ?? 'email';
    settingsResult?.notificationType = notifyValue;
    notifyListeners();
  }

  changeLanguage(dynamic value) {
    this.languageValue = value ?? 'en_GB';
    settingsResult?.lang = languageValue;
    notifyListeners();
  }

  onChangeEmail(String value) {
    this.email = value;
    settingsResult?.email = email;
    validate;
    notifyListeners();
  }

  initAvatar() async {
    await CachedImageBase64Manager.instance().removeFile('app://image/1');
  }

  void takePhoto() async {
    //do not need request camera permission
    /*if (!(await PermissionUtils.camera())) {
      return;
    }*/
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePath = image.path;
    }
    final byteData = await image?.readAsBytes();

    if (byteData != null) {
      imageByte = byteData;
      settingsResult?.image1024 = base64Encode(byteData);
      final tempPath = (await getTemporaryDirectory()).path;
      final filePath = tempPath + 'tempAvatar.jpg';
      final avatarFileTemp =
          await File(filePath).writeAsBytes(byteData.toList());
      // _createUser = _createUser.copyWith(avatar: avatarFileTemp.path);
      notifyListeners();
    }
    _navigationService.back();
  }

  void pickImage() async {
    if (!(await PermissionUtils.storage())) {
      return;
    }
    try {
      final files = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpeg',
          'jpg',
          'png',
          'heic',
        ],
        allowCompression: true,
      ))
          ?.files;
      if (files != null && files.isNotEmpty) {
        imagePath = files[0].path;
        await readFileByte(files.first.path).then((bytesData) {
          if (bytesData != null) {
            imageByte = bytesData;
            settingsResult?.image1024 = base64Encode(bytesData);
            notifyListeners();
            /* _createUser = _createUser.copyWith(
              avatar: files[0].path,
            );*/
          }
        });
      }
    } catch (e) {
      print(e);
    }
    _navigationService.back();
  }

  LanguagesResponse? _languagesResponse;

  LanguagesResponse? get languagesResponse => _languagesResponse;

  set languagesResponse(LanguagesResponse? languagesResponse) {
    _languagesResponse = languagesResponse;
    notifyListeners();
  }

  Future<void> getLanguagesApi() async {
    SessionInfo? sessionInfo = userSharePref.getUser();
    Map<String, dynamic> kwargs = <String, dynamic>{};
    kwargs.putIfAbsent('context', () => sessionInfo?.userContext);
    kwargs.putIfAbsent('fields', () =>  [
      "name",
      "code"
    ]);

    EasyLoading.show();
    final subscript =
        _dataRepo.callKW(RES_LANG, SEARCH_READ, kwargs: kwargs).listen((r) {
      try {
        languagesResponse = LanguagesResponse.fromJson(r);
        selectionLang = languagesResponse!.result ?? [];
        notifyListeners();
      } catch (e) {
        print(e);
        _navigationService.openErrorPage(
            message: r is DioError && r.message.isNotEmpty
                ? r.message.toString()
                : LocaleKeys.an_unexpected_error_has_occurred.tr());
      } finally {
        EasyLoading.dismiss();
        notifyListeners();
      }
    });
    addSubscription(subscript);
  }

  SettingsResponse? _settingsResponse;

  SettingsResponse? get settingsResponse => _settingsResponse;

  set settingsResponse(SettingsResponse? settingsResponse) {
    _settingsResponse = settingsResponse;
    notifyListeners();
  }

  Future<void> getSettingsApi() async {
    SessionInfo? sessionInfo = userSharePref.getUser();
    Map<String, dynamic> kwargs = <String, dynamic>{};
    kwargs.putIfAbsent('context', () => sessionInfo?.userContext);
    List<dynamic> args = [
      [sessionInfo?.uid],
      [
        "avatar_128",
        "image_1024",
        "__last_update",
        "name",
        "notification_type",
        "odoobot_state",
        "email",
        "lang",
        "tz",
        "tz_offset",
        "signature",
        "company_id",
        "totp_enabled",
        "api_key_ids",
        "display_name"
      ]
    ];
    //EasyLoading.show();
    final subscript = _dataRepo
        .callKW(RES_USER, READ, kwargs: kwargs, args: args)
        .listen((r) {
      try {
        settingsResponse = SettingsResponse.fromJson(r);
        if (settingsResponse?.result != null &&
            settingsResponse!.result!.isNotEmpty) {
          settingsResult = settingsResponse!.result![0];
          notifyValue = settingsResult?.notificationType;
          languageValue = settingsResult?.lang;
          emailController.text = settingsResult?.email ?? '';
          imageByte = Utils.dataFromBase64String(settingsResult?.image1024 ?? '');
          onChangeEmail(settingsResult?.email ?? '');
          notifyListeners();
        }
      } catch (e) {
        print(e);
        _navigationService.openErrorPage(
            message: r is DioError && r.message.isNotEmpty
                ? r.message.toString()
                : LocaleKeys.an_unexpected_error_has_occurred.tr());
      } finally {
        EasyLoading.dismiss();
      }
    });
    addSubscription(subscript);
  }

  ShopsResponse? _shopsResponse;

  ShopsResponse? get shopsResponse => _shopsResponse;

  set shopsResponse(ShopsResponse? shopsResponse) {
    _shopsResponse = shopsResponse;
    notifyListeners();
  }

  void saveSettings() async {
    SessionInfo? sessionInfo = userSharePref.getUser();
    Map<String, dynamic> kwargs = <String, dynamic>{};
    kwargs.putIfAbsent('context', () => sessionInfo?.userContext);
    List<dynamic> args = [
      [sessionInfo?.uid],
      settingsResult?.toJson()
    ];
    EasyLoading.show();
    final subscript = _dataRepo
        .callKW(RES_USER, WRITE, kwargs: kwargs, args: args)
        .listen((r) {
      try {
        SaveSettingsResponse saveSettingsResponse = SaveSettingsResponse.fromJson(r);
        if (saveSettingsResponse.result) {
          ToastUtil.showToast(LocaleKeys.profile_update_successfully.tr());
          _navigationService.back();
        }
      } catch (e) {
        print(e);
        _navigationService.openErrorPage(
            message: r is DioError && r.message.isNotEmpty
                ? r.message.toString()
                : LocaleKeys.an_unexpected_error_has_occurred.tr());
      } finally {
        EasyLoading.dismiss();
      }
    });
    addSubscription(subscript);
  }
}
