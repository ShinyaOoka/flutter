import 'dart:io';

import 'package:ak_azm_flutter/app/model/ms_classification.dart';
import 'package:ak_azm_flutter/app/model/ms_team.dart';
import 'package:ak_azm_flutter/app/model/ms_team_member.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/snack_bar_util.dart';
import 'package:ak_azm_flutter/app/module/database/column_name.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/flutter_easyloading/src/easy_loading.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';
import '../../di/injection.dart';
import '../../module/common/extension.dart';
import '../../module/common/navigator_screen.dart';
import '../../module/common/toast_util.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/network/dio_module.dart';
import '../../module/network/response/databases_response.dart';
import '../../module/repository/data_repository.dart';
import '../../viewmodel/base_viewmodel.dart';

class InputReportViewModel extends BaseViewModel {
  final DataRepository _dataRepo;
  final NavigationService _navigationService = getIt<NavigationService>();
  UserSharePref userSharePref = getIt<UserSharePref>();
  final serverFC = FocusNode();
  final portFC = FocusNode();
  String server = '';
  String port = '';
  var serverController = TextEditingController();
  var portController = TextEditingController();


  List<MSClassification>  msClassifications= [];
  List<MSTeam>  msTeams= [];
  List<MSTeamMember>  msTeamMembers= [];
  //layout 1
  List<String> yesNothings = [LocaleKeys.yes_dropdown.tr(), LocaleKeys.nothing.tr()];
  List<String> group1No7 = ['保科　久穂',
    '大岡　慎弥',
    '中村　健',
    '鷹巣　良右',
    '柳下　清隆',
    '青木　栄介',
    '松岡　和人',
    '福島　隼人'];
  bool isExpandQualification = false;
  bool isExpandRide = false;

  //layout 1
  String? ambulanceName;
  String? ambulanceTel;
  String? captainName;
  String? emtQualification;
  String? reportMemberName;
  String? reportNameOfEngineer;
  String? emtRide;



  //layout 2
  String? dosage;
  String? sex;
  String? birthday = '';
  String? age = '';


  //layout 3
  String? awareness_time = '';
  String? command_time = '';
  String? work_time = '';
  String? arrival_on_site = '';
  String? contact_time = '';
  String? in_car_accommodation = '';
  String? start_transportation = '';
  String? arrival_at_hospital = '';
  String? family_contact = '';
  String? police_contact = '';
  String? report_cash_on_delivery_time = '';
  String? report_return_time = '';




  List<dynamic> databaseList = [];
  DatabasesResponse? _databasesResponse;

  set databasesResponse(DatabasesResponse? databasesResponse) {
    _databasesResponse = databasesResponse;
    notifyListeners();
  }

  Future<bool> back() async {
    _navigationService.back();
    return true;
  }

  Future<void> getAllMSClassification() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSClassification) ?? [];
    msClassifications = datas.map((e) => MSClassification.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSTeam() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSTeam) ?? [];
    msTeams = datas.map((e) => MSTeam.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getAllMSTeamMember() async {
    List<Map<String, Object?>>? datas = await dbHelper.getAllData(tableMSTeamMember) ?? [];
    msTeamMembers = datas.map((e) => MSTeamMember.fromJson(e)).toList();
    notifyListeners();
  }

  void initData() {
    getAllMSClassification();
    getAllMSTeam();
    getAllMSTeamMember();
  }

  DatabasesResponse? get databasesResponse => _databasesResponse;

  InputReportViewModel(this._dataRepo);

  bool get validate =>
      (server.isNotEmpty &&
          (Utils.isURL(server) ||
              Utils.isIPv4(server) ||
              Utils.isIPv6(server))) &&
      (port.isNotEmpty && Utils.isNum(port) && port.length <= 10);

  onChangeServer(String value) {
    this.server = value.trim();
    notifyListeners();
  }

  onChangePort(String value) {
    this.port = value.trim();
    validate;
    notifyListeners();
  }

  onSelectAmbulanceName(String? itemSelected) {
    this.ambulanceName = itemSelected ?? '';
    MSTeam? msTeam = msTeams.firstWhere((e) => e.Name == itemSelected);
    onSelectAmbulanceTel (msTeam.TEL ?? '');
    notifyListeners();
  }
  onSelectAmbulanceTel(String? itemSelected) {
    this.ambulanceTel = itemSelected ?? '';
    notifyListeners();
  }

  onSelectCaptainName(String? itemSelected) {
    this.captainName = itemSelected ?? '';
    notifyListeners();
  }

  onSelectQualification(String? itemSelected) {
    this.emtQualification = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectRide(String? itemSelected) {
    this.emtRide = itemSelected ?? yesNothings[1];
    notifyListeners();
  }

  onSelectReportMemberName(String? itemSelected) {
    this.reportMemberName = itemSelected ?? '';
    notifyListeners();
  }

  onSelectReportNameOfEngineer(String? itemSelected) {
    this.reportNameOfEngineer = itemSelected ?? '';
    notifyListeners();
  }


  //layout 2
  onConfirmBirthday(DateTime date) {
    this.birthday = Utils.dateTimeToString(date, format: yyyy_MM_dd_);
    this.age = Utils.calculateAge(date).toString();
    notifyListeners();
  }

  onSelectSex(String? itemSelected) {
    this.sex = itemSelected ?? '';
    notifyListeners();
  }

  onSelectDosage(String? itemSelected) {
    this.dosage = itemSelected ?? '';
    notifyListeners();
  }

  onConfirmAwarenessTime(DateTime date) {
    this.awareness_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmCommandTime(DateTime date) {
    this.command_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmWorkTime(DateTime date) {
    this.work_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
onConfirmArrivalOnSite(DateTime date) {
    this.arrival_on_site = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmContactTime(DateTime date) {
    this.contact_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmInCarAccommodation(DateTime date) {
    this.in_car_accommodation = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmStartTransportation(DateTime date) {
    this.start_transportation = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }
  onConfirmArrivalAtHospital(DateTime date) {
    this.arrival_at_hospital = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmFamilyContact(DateTime date) {
    this.family_contact = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmPoliceContact(DateTime date) {
    this.police_contact = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmReportCashOnDeliveryTime(DateTime date) {
    this.report_cash_on_delivery_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }

  onConfirmReportReturnTime(DateTime date) {
    this.report_return_time = Utils.dateTimeToString(date, format: hh_mm_);
    notifyListeners();
  }


  String? invalidServer(String? value) {
    return value == null ||
            !(Utils.isURL(server.trim()) ||
                Utils.isIPv4(server.trim()) ||
                Utils.isIPv6(server.trim()))
        ? LocaleKeys.invalid_server.tr()
        : null;
  }

  String? invalidPort(String? value) {
    return value == null || !Utils.isNum(port) || !(port.length <= 10)
        ? LocaleKeys.invalid_port.tr()
        : null;
  }



  void submit() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);

  }

  //check is server = call api get database
  void getDatabasesApi() async {
    removeFocus(_navigationService.navigatorKey.currentContext!);
    final subscript = _dataRepo.getDatabases().doOnListen(() {
      EasyLoading.show();
    }).doOnDone(() {
      EasyLoading.dismiss();
    }).listen((r) {
      try {
        databasesResponse = DatabasesResponse.fromJson(r);
        if (databasesResponse?.result != null &&
            databasesResponse!.result is List) {
          databaseList = databasesResponse!.result ?? [];
          notifyListeners();
          //_navigationService.pushScreenNoAnim(SignInPage(databaseList: databaseList,));
        }
      } catch (e) {
        SnackBarUtil.showSnack(title: LocaleKeys.something_is_not_right.tr(), message: LocaleKeys.please_check_your_url.tr(), snackType: SnackType.ERROR);
      } finally {
        notifyListeners();
      }
    });
    addSubscription(subscript);
  }




  void openSignIn() {
    getDatabasesApi();
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
