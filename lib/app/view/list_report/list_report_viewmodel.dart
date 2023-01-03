import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:ak_azm_flutter/app/module/database/column_name.dart';
import 'package:ak_azm_flutter/app/module/database/db_helper.dart';
import 'package:ak_azm_flutter/app/view/confirm_report/confirm_report_page.dart';
import 'package:ak_azm_flutter/app/view/input_report/input_report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../di/injection.dart';
import '../../module/common/config.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../edit_report/edit_report_page.dart';

class ListReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  DBHelper dbHelper = getIt<DBHelper>();

  double endReachedThreshold = 200;
  bool isLoading = false;
  bool canLoadMore = false;
  LoadingState loadingState = LoadingState.LOADING;
  List<DTReport> dtReports = [];
  List<MSClassification> msClassifications = [];

  final ScrollController scrollController = ScrollController();

  ListReportViewModel(this._dataRepo);

  void openCreateReport() async {
    _navigationService.pushScreenWithFade(InputReportPage());
  }

  void openEditReport() async {
    _navigationService.pushScreenWithFade(EditReportPage());
  }

  void openConfirmReport() async {
    _navigationService.pushScreenWithFade(ConfirmReportPage());
  }

  Future<void> getAllMSClassification() async {
    List<Map<String, Object?>>? datas =
        await dbHelper.getAllData(tableMSClassification) ?? [];
    msClassifications = datas.map((e) => MSClassification.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getReports() async {
    dtReports = await dbHelper.getAllReport() ?? [];
    if (dtReports.isEmpty)
      loadingState = LoadingState.EMPTY;
    else
      loadingState = LoadingState.DONE;
    notifyListeners();
  }

  refreshData() {
    isLoading = false;
    canLoadMore = false;
    loadingState = LoadingState.LOADING;
    //reports.clear();
    getReports();
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
    //ToastUtil.showToast(LocaleKeys.press_the_back_button_to_exit.tr());
    Future.delayed(Duration(seconds: 2), () {
      doubleBackToExit = false;
    });
    return false;
  }
}
