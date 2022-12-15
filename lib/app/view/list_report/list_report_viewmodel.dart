import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/app/module/common/toast_util.dart';
import 'package:ak_azm_flutter/app/view/input_report/input_report_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../di/injection.dart';
import '../../model/login_config.dart';
import '../../model/login_data.dart';
import '../../module/common/config.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/snack_bar_util.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/response/login_response.dart';
import '../../module/repository/data_repository.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../edit_report/edit_report_page.dart';
import '../home/home_page.dart';
import '../preview_report/preview_report_page.dart';
import '../widget_utils/custom/flutter_easyloading/src/easy_loading.dart';
import '../widget_utils/dialog/dialog_general_two_action.dart';

class ListReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();

  double endReachedThreshold = 200;
  bool isLoading = false;
  bool canLoadMore = false;
  LoadingState loadingState = LoadingState.LOADING;
  List<LoginConfig> loginDataList = [];

  final ScrollController scrollController = ScrollController();

  ListReportViewModel(this._dataRepo);

  LoginResponse? _loginResponse;

  set loginResponse(LoginResponse? loginResponse) {
    _loginResponse = loginResponse;
    notifyListeners();
  }

  void openCreateReport() async {
    _navigationService.pushScreenWithFade(InputReportPage());
  }

  void openEditReport() async {
    _navigationService.pushScreenWithFade(EditReportPage());
  }

  void openPreviewReport() async {
    _navigationService.pushScreenWithFade(PreviewReportPage());
  }

  LoginResponse? get loginResponse => _loginResponse;

  Future<void> getLoginData() async {
    loginDataList = await userSharePref.getLoginDataList()?.data ?? [];
    if (loginDataList.isEmpty)
      loadingState = LoadingState.EMPTY;
    else
      loadingState = LoadingState.DONE;
    notifyListeners();
  }

  refreshData() {
    isLoading = false;
    canLoadMore = false;
    loadingState = LoadingState.LOADING;
    loginDataList.clear();
    getLoginData();
    notifyListeners();
  }

  void onScroll() {
    if (!scrollController.hasClients || isLoading) return;
    final thresholdReached =
        scrollController.position.extentAfter < endReachedThreshold;
    if (thresholdReached) {
      // Load more!
    }
  }

  void signInApi(LoginConfig? loginConfig) async {
    //save login config
    userSharePref.saveLoginConfig(loginConfig);
    removeFocus(_navigationService.navigatorKey.currentContext!);
    String database = loginConfig?.database ?? '';
    String email = loginConfig?.email ?? '';
    String password = loginConfig?.password ?? '';
    final subscript = _dataRepo
        //.callKW(POS_CATEGORY, SEARCH_READ, kwargs: kwargs, )
        .authenticate(email, password, database)
        .doOnListen(() {
      EasyLoading.show();
    }).doOnDone(() {
      EasyLoading.dismiss();
    }).listen((r) {
      try {
        loginResponse = LoginResponse.fromJson(r);
        if (loginResponse?.result != null) {
          if (loginResponse?.result!.uid == null) {
            openAuthenticationPage();
          } else {
            userSharePref.saveUser(loginResponse?.result);
            openHomePage();
          }
        } else {
          SnackBarUtil.showSnack(
              title: LocaleKeys.something_is_not_right.tr(),
              message: LocaleKeys.please_check_your_email_or_password.tr(),
              snackType: SnackType.ERROR);
        }
      } catch (e) {
        _navigationService.openErrorPage(
            message: r is DioError && r.message.isNotEmpty
                ? r.message.toString()
                : LocaleKeys.an_unexpected_error_has_occurred.tr());
      } finally {
        notifyListeners();
      }
    });
    addSubscription(subscript);
  }

  void openAuthenticationPage() async {
   // _navigationService.pushReplacementScreenWithSlideRightIn(AuthenticationPage());
  }



  void openHomePage() async {
    _navigationService.pushReplacementScreenWithSlideRightIn(HomePage());
  }

  void openSignInPage() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);
    //clear data login config
    userSharePref.saveLoginConfig(null);
   // _navigationService.pushScreenWithFade(InputServerPortPage());
  }

  void deleteAccount(LoginConfig loginConfig) {
    showDialog(
        context: _navigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return DialogGeneralTwoAction(
            title: LocaleKeys.delete_account.tr(),
            message: LocaleKeys.do_you_want_to_delete_account.tr(namedArgs: {'account_name': loginConfig.userName ?? ''}),
            textOk: LocaleKeys.delete.tr(),
            onOkClick: () async {
              EasyLoading.show();
              loginDataList.remove(loginConfig);
              //save login data
              LoginData loginData =
                  userSharePref.getLoginDataList() ?? LoginData(data: []);
              loginData.data = loginDataList;
              await userSharePref.saveLoginDataList(loginData);
              Future.delayed(Duration(milliseconds: 500), () {
                EasyLoading.dismiss();
                if (loginDataList.isEmpty)
                  openSignInPage();
                else
                  loadingState = LoadingState.DONE;
                notifyListeners();
                },);

            },
          );
        });
  }

  bool doubleBackToExit = false;

  Future<bool> onDoubleBackToExit() async {
    if (doubleBackToExit) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      return true;
    }
    doubleBackToExit = true;
    ToastUtil.showToast(LocaleKeys.press_the_back_button_to_exit.tr());
    Future.delayed(Duration(seconds: 2), () {
      doubleBackToExit = false;
    });
    return false;
  }
}
