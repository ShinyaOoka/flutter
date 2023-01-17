// ignore_for_file: body_might_complete_normally_nullable

import 'package:ak_azm_flutter/app/model/object_search.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/extension.dart';
import 'package:ak_azm_flutter/app/module/common/toast_util.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/checkbox_group.dart';
import 'package:ak_azm_flutter/generated/locale_keys.g.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../module/common/config.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../../viewmodel/life_cycle_base.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import '../widget_utils/buttons/filled_button.dart';
import '../widget_utils/custom/search_choices.dart';
import '../widget_utils/expansion_panel_custom.dart';
import '../widget_utils/outline_text_form_field.dart';
import 'input_report_viewmodel.dart';

class InputReportPage extends PageProvideNode<InputReportViewModel> {
  InputReportPage() : super();

  @override
  Widget buildContent(BuildContext context) {
    return InputReportContent(viewModel);
  }
}

class InputReportContent extends StatefulWidget {
  final InputReportViewModel _inputReportViewModel;

  InputReportContent(this._inputReportViewModel);

  @override
  InputReportState createState() => InputReportState();
}

class InputReportState extends LifecycleState<InputReportContent>
    with SingleTickerProviderStateMixin {
  InputReportViewModel get inputReportViewModel => widget._inputReportViewModel;
  final List<Item> data = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InputReportContent oldWidget) {
    init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void onResume() {
    init();
    super.onResume();
  }

  void init() {
    data.add(Item(headerValue: LocaleKeys.participation_information.tr()));
    data.add(Item(headerValue: LocaleKeys.victim_information.tr()));
    data.add(Item(headerValue: LocaleKeys.time_elapsed.tr()));
    data.add(Item(headerValue: LocaleKeys.occurrence_status.tr()));
    data.add(Item(headerValue: LocaleKeys.vital_signs_appearance_1.tr()));
    data.add(Item(headerValue: LocaleKeys.treatment.tr()));
    data.add(Item(headerValue: LocaleKeys.vital_signs_appearance_2.tr()));
    data.add(Item(headerValue: LocaleKeys.vital_signs_appearance_3.tr()));
    data.add(Item(headerValue: LocaleKeys.delivery_information.tr()));
    data.add(Item(headerValue: LocaleKeys.report_transport_information.tr()));
    data.add(Item(headerValue: LocaleKeys.report_reporter.tr()));
    data.add(Item(headerValue: LocaleKeys.report_remarks.tr()));
    inputReportViewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => inputReportViewModel.back(),
        child: BaseScaffoldSafeArea(
          customAppBar: AppBar(
            backgroundColor: kColor4472C4,
            centerTitle: true,
            title: Text(
              LocaleKeys.report_new_entry.tr(),
              // style: Theme.of(context).appBarTheme.titleTextStyle,
              style: TextStyle(
                fontSize: text_16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: TextButton(
              child: Text(LocaleKeys.back_report.tr(),
                  // style: Theme.of(context).appBarTheme.titleTextStyle,
                  style: TextStyle(
                    fontSize: text_16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
              onPressed: () => inputReportViewModel.back(),
            ),
            actions: [
              TextButton(
                child: Text(LocaleKeys.register_report.tr(),
                    // style: Theme.of(context).appBarTheme.titleTextStyle,
                    style: TextStyle(
                      fontSize: text_16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () => inputReportViewModel.onSaveToDb(),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          transparentStatusBar: 0.0,
          title: '',
          hideBackButton: false,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: FilledButton(
                          borderRadius: size_4_r,
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                          color: kColor4472C4,
                          text: LocaleKeys.x_series_data_acquisition.tr(),
                          onPress: () => ToastUtil.showToast(
                              LocaleKeys.x_series_data_acquisition.tr()),
                        ),
                      ),
                      _buildPanel(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildPanel() {
    return ExpansionPanelListRemovePaddingTopBottom(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.black26,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          data[index].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((Item item) {
        int indexLayout = data.indexOf(item) + 1;
        return ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: indexLayout == 9 ||
                  indexLayout == 10 ||
                  indexLayout == 11 ||
                  indexLayout == 12
              ? kColorDEE9F6
              : null,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('$indexLayout. ${item.headerValue}'),
            );
          },
          body: buildLayoutContent(indexLayout),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Widget buildLayoutContent(int index) {
    switch (index) {
      case 1:
        return buildLayout1();

      case 2:
        return buildLayout2();

      case 3:
        return buildLayout3();

      case 4:
        return buildLayout4();

      case 5:
        return buildLayout5();

      case 6:
        return buildLayout6();

      case 7:
        return buildLayout7();

      case 8:
        return buildLayout8();

      case 9:
        return buildLayout9();

      case 10:
        return buildLayout10();

      case 11:
        return buildLayout11();

      case 12:
        return buildLayout12();

      default:
        return Container();
    }
  }

  bool useMobileLayout() {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide <= 500;
  }

  Widget buildLayout1() {
    bool isWidescreen = MediaQuery.of(context).size.width >= 500;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDownSearchObject(
                            LocaleKeys.ambulance_name.tr(),
                            value.msTeams
                                .map((e) =>
                                    ObjectSearch(CD: e.TeamCD, Name: e.Name))
                                .toList(),
                            value.ambulanceName,
                            value.onSelectAmbulanceName);
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return OutlineTextFormField(
                          keyboardType: TextInputType.number,
                          isAlwaysShowLable: true,
                          controller: TextEditingController(
                              text: value.dtReport.TeamTEL),
                          counterWidget: null,
                          textColor: kColor4472C4,
                          colorBorder: Colors.black26,
                          colorFocusBorder: kColor4472C4,
                          labelText: LocaleKeys.ambulance_tel.tr(),
                          onChanged: (value) => null,
                        );
                      }),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return textShowWithLabel(LocaleKeys.fire_signature.tr(),
                            value.dtReport.FireStationName ?? '');
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDownSearchObject(
                            LocaleKeys.captain_name.tr(),
                            value.msTeamMembers
                                .map((e) => ObjectSearch(
                                    CD: e.TeamMemberCD, Name: e.Name))
                                .toList(),
                            value.captainName,
                            value.onSelectCaptainName);
                      }),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return textShowWithLabel(
                            LocaleKeys.emt_qualification.tr(),
                            value.emtQualification ?? '');
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return textShowWithLabel(
                            LocaleKeys.emt_ride.tr(), value.emtRide ?? '');
                      }),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDownSearchObject(
                            LocaleKeys.report_member_name.tr(),
                            value.msTeamMembers
                                .map((e) => ObjectSearch(
                                    CD: e.TeamMemberCD, Name: e.Name))
                                .toList(),
                            value.memberName,
                            value.onSelectReportMemberName,
                            backgroundTextLabel: kColorDEE9F6);
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDownSearchObject(
                            LocaleKeys.report_name_of_engineer.tr(),
                            value.msTeamMembers
                                .map((e) => ObjectSearch(
                                    CD: e.TeamMemberCD, Name: e.Name))
                                .toList(),
                            value.nameOfEngineer,
                            value.onSelectReportNameOfEngineer,
                            backgroundTextLabel: kColorDEE9F6);
                      }),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: OutlineTextFormField(
                        keyboardType: TextInputType.number,
                        isAlwaysShowLable: true,
                        maxLength: 6,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.report_cumulative_total.tr(),
                        onChanged: (value) => inputReportViewModel
                            .onChangeReportCumulativeTotal(value),
                      ),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: OutlineTextFormField(
                        keyboardType: TextInputType.number,
                        isAlwaysShowLable: true,
                        maxLength: 6,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.report_team.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeReportTeam(value),
                      ),
                      flex: 1)
                ],
              )),
        ]);
  }

  Widget buildLayout2() {
    bool isWidescreen = MediaQuery.of(context).size.width >= 500;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.family_name.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeFamilyName(value),
                      ),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Focus(
                          child: OutlineTextFormField(
                            isAlwaysShowLable: true,
                            keyboardType: TextInputType.text,
                            maxLength: 20,
                            counterStyle: counterStyle,
                            textColor: kColor4472C4,
                            colorBorder: Colors.black26,
                            colorFocusBorder: kColor4472C4,
                            labelText: LocaleKeys.furigana.tr(),
                            controller: inputReportViewModel.furiganaController,
                            onChanged: (value) =>
                                inputReportViewModel.onChangeFurigana(value),
                          ),
                          onFocusChange: (hasFocus) => !hasFocus
                              ? inputReportViewModel.onUnfocusFurigana()
                              : null),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          //no.15
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 60,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.address.tr(),
              onChanged: (value) => inputReportViewModel.onChangeAddress(value),
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(
                            LocaleKeys.sex.tr(),
                            value.msClassifications
                                .where((element) =>
                                    element.ClassificationCD == '001')
                                .toList()
                                .map((e) => e.Value.toString())
                                .toList(),
                            value.onSelectSex);
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return datePicker(
                            LocaleKeys.birthday.tr(),
                            value.dtReport.SickInjuredPersonBirthDate,
                            value.onConfirmBirthday);
                      }),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.phone,
                        inputformatter: [
                          FilteringTextInputFormatter.allow(allowPhoneNumber),
                        ],
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.tel.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeTel(value),
                      ),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        inputformatter: [
                          FilteringTextInputFormatter.allow(allowPhoneNumber),
                        ],
                        keyboardType: TextInputType.phone,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.family_phone.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeFamilyPhone(value),
                      ),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.medical_history.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeMedicalHistory(value),
                      ),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText:
                            LocaleKeys.medical_history_medical_institution.tr(),
                        onChanged: (value) => inputReportViewModel
                            .onChangeMedicalHistoryMedicalInstitution(value),
                      ),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.family.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeFamily(value),
                      ),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(
                            LocaleKeys.dosage.tr(),
                            value.msClassifications
                                .where((element) =>
                                    element.ClassificationCD == '010')
                                .toList()
                                .map((e) => e.Value.toString())
                                .toList(),
                            value.onSelectDosage);
                      }),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.dosing_details.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeDosingDetails(value),
                      ),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.allergy.tr(),
                        onChanged: (value) =>
                            inputReportViewModel.onChangeAllergy(value),
                      ),
                      flex: 1)
                ],
              )),
          spaceWidgetColor(),
          //no.26
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16, top: 12),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 60,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.report_name_of_injury_or_disease.tr(),
              onChanged: (value) => inputReportViewModel
                  .onChangeReportNameOfInjuryOrDisease(value),
            ),
          ),
          spaceWidgetColor(color: kColorDEE9F6),
          //no.27
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 60,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.report_degree.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeReportDegree(value),
            ),
          ),
          spaceWidgetColor(color: kColorDEE9F6),
          //no.28
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return textShowWithLabel(LocaleKeys.report_age.tr(),
                  value.dtReport.SickInjuredPersonAge?.toString() ?? '',
                  backgroundLableColor: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(color: kColorDEE9F6, height: size_28_w),
        ]);
  }

  Widget buildLayout3() {
    bool isWidescreen = MediaQuery.of(context).size.width >= 500;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.awareness_time.tr(),
                            value.dtReport.SenseTime,
                            value.onConfirmAwarenessTime);
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.command_time.tr(),
                            value.dtReport.CommandTime,
                            value.onConfirmCommandTime);
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                    child: Consumer<InputReportViewModel>(
                        builder: (context, value, child) {
                      return timePicker(
                          LocaleKeys.work_time.tr(),
                          value.dtReport.AttendanceTime,
                          value.onConfirmWorkTime);
                    }),
                  )
                ],
              )),
          spaceWidgetColor(),
          Container(
              padding: EdgeInsets.only(right: 16),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                children: [
                  SizedBox(width: 16),
                  Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.arrival_on_site.tr(),
                            value.dtReport.OnsiteArrivalTime,
                            value.onConfirmArrivalOnSite);
                      }),
                      flex: 1),
                  SizedBox(width: 16),
                  Expanded(
                    child: Consumer<InputReportViewModel>(
                        builder: (context, value, child) {
                      return timePicker(
                          LocaleKeys.contact_time.tr(),
                          value.dtReport.ContactTime,
                          value.onConfirmContactTime);
                    }),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Consumer<InputReportViewModel>(
                        builder: (context, value, child) {
                      return timePicker(
                          LocaleKeys.in_car_accommodation.tr(),
                          value.dtReport.InvehicleTime,
                          value.onConfirmInCarAccommodation);
                    }),
                  )
                ],
              )),
          spaceWidgetColor(),
          //no.36
          Container(
              padding: const EdgeInsets.only(right: 16),
              child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.start_transportation.tr(),
                            value.dtReport.StartOfTransportTime,
                            value.onConfirmStartTransportation);
                      }),
                    ),
                    //no.37
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.arrival_at_hospital.tr(),
                            value.dtReport.HospitalArrivalTime,
                            value.onConfirmArrivalAtHospital);
                      }),
                    ),
                    //no.38
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.family_contact.tr(),
                            value.dtReport.FamilyContactTime,
                            value.onConfirmFamilyContact);
                      }),
                    ),
                  ])),

          spaceWidgetColor(),
          //no.39
          Container(
              padding: const EdgeInsets.only(right: 16),
              child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.police_contact.tr(),
                            value.dtReport.PoliceContactTime,
                            value.onConfirmPoliceContact);
                      }),
                    ),
                    //no.40
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.report_cash_on_delivery_time.tr(),
                            value.dtReport.TimeOfArrival,
                            value.onConfirmReportCashOnDeliveryTime,
                            backgroundLableColor: kColorDEE9F6);
                      }),
                    ),
                    //no.41
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.report_return_time.tr(),
                            value.dtReport.ReturnTime,
                            value.onConfirmReportReturnTime,
                            backgroundLableColor: kColorDEE9F6);
                      }),
                    ),
                  ])),

          spaceWidgetColor(),
        ]);
  }

  Widget buildLayout4() {
    bool isWidescreen = MediaQuery.of(context).size.width >= 500;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(right: 16),
              child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(
                          LocaleKeys.accident_type_input.tr(),
                          value.msClassifications
                              .where((element) =>
                                  element.ClassificationCD == '002')
                              .toList()
                              .map((e) => e.Value.toString())
                              .toList(),
                          value.onSelectAccidentTypeInput,
                        );
                      }),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            child: Consumer<InputReportViewModel>(
                                builder: (context, value, child) {
                              return datePicker(
                                  LocaleKeys.accrual_date.tr(),
                                  value.dtReport.DateOfOccurrence,
                                  value.onConfirmAccrualDate);
                            }),
                            flex: 1,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Consumer<InputReportViewModel>(
                                builder: (context, value, child) {
                              return timePicker(
                                  LocaleKeys.occurrence_time.tr(),
                                  value.dtReport.TimeOfOccurrence,
                                  value.onConfirmOccurrenceTime);
                            }),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  ])),
          spaceWidgetColor(),
          //no.43
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 100,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.place_of_occurrence.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangePlaceOfOccurrence(value),
            ),
          ),

          spaceWidgetColor(),
          //No.47
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 100,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText:
                  LocaleKeys.summary_of_accident_and_chief_complaint.tr(),
              onChanged: (value) => inputReportViewModel
                  .onChangeSummaryOfAccidentAndChiefComplaint(value),
            ),
          ),
          spaceWidgetColor(),
          //no.48
          Container(
              padding: const EdgeInsets.only(right: 16),
              child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(
                          LocaleKeys.adl.tr(),
                          value.msClassifications
                              .where((element) =>
                                  element.ClassificationCD == '003')
                              .toList()
                              .map((e) => e.Value.toString())
                              .toList(),
                          value.onSelectAdl,
                        );
                      }),
                    ),

                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(
                          LocaleKeys.traffic_accident_category.tr(),
                          value.msClassifications
                              .where((element) =>
                                  element.ClassificationCD == '004')
                              .toList()
                              .map((e) => e.Value.toString())
                              .toList(),
                          value.onSelectTrafficAccidentCategory,
                        );
                      }),
                    ),

                    //no.50
                  ])),
          spaceWidgetColor(),

          Container(
              padding: const EdgeInsets.only(right: 16),
              child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  direction: isWidescreen ? Axis.horizontal : Axis.vertical,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(LocaleKeys.witness.tr(),
                            yesNothings, value.onSelectWitness);
                      }),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Consumer<InputReportViewModel>(
                          builder: (context, value, child) {
                        return timePicker(
                            LocaleKeys.bystander_cpr.tr(),
                            value.dtReport.BystanderCPR,
                            value.onConfirmBystanderCpr);
                      }),
                    ),
                  ])),

          spaceWidgetColor(),
          //no.52
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 60,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.oral_instruction.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeOralInstruction(value),
            ),
          ),
          spaceWidgetColor(),
        ]);
  }

  Widget buildLayout5() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //no.54
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return timePicker(LocaleKeys.observation_time.tr(),
                  value.observationTime1, value.onConfirmObservationTime1);
            }),
          ),
          spaceWidgetColor(),
          //no.55
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                LocaleKeys.jcs.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '011')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.onSelectJcs1,
              );
            }),
          ),
          spaceWidgetColor(),
          //no.57,58,59
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDown(
                      LocaleKeys.gcs_e.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '012')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.onSelectGcsE1,
                    );
                  }),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDown(
                      LocaleKeys.gcs_v.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '013')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.onSelectGcsV1,
                    );
                  }),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDown(
                      LocaleKeys.gcs_m.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '014')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.onSelectGcsM1,
                    );
                  }),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.60
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_times_minute.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.breathing.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBreathing1(value),
            ),
          ),
          spaceWidgetColor(),
          //no.61
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_times_minute.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.pulse.tr(),
              onChanged: (value) => inputReportViewModel.onChangePulse1(value),
            ),
          ),
          spaceWidgetColor(),
          //no.62 & 63
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.blood_pressure_up.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeBloodPressureUp1(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.blood_pressure_lower.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeBloodPressureLower1(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),
          //no.64 & 65
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_percent.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.spo2_percent.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeSpo2Percent1(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_L.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.spo2_l.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeSpo2L1(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),
          //no.66 & 67
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mm.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.right_pupil.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeRightPupil1(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mm.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.left_pupil.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeLeftPupil1(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.68
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.light_reflection_right.tr(),
                  yesNothings, value.onSelectLightReflectionRight1);
            }),
          ),
          spaceWidgetColor(),
          //no.69
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.light_reflection_left.tr(),
                  yesNothings, value.onSelectLightReflectionLeft1);
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.70
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_C.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.body_temperature.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBodyTemperature1(value),
            ),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.71
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                LocaleKeys.facial_features.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '005')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.onSelectFacialFeatures1,
              );
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.72
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.bleeding.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBleeding1(value),
            ),
          ),
          spaceWidgetColor(
            height: size_6_w,
          ),
          //no.73
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                  LocaleKeys.incontinence.tr(),
                  value.msClassification006s
                      .map((e) => e.Value.toString())
                      .toList(),
                  value.onSelectIncontinence1);
            }),
          ),
          spaceWidgetColor(),
          //no.74
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.vomiting.tr(), yesNothings,
                  value.onSelectVomiting1);
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.75
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.limb.tr(),
              onChanged: (value) => inputReportViewModel.onChangeLimb1(value),
            ),
          ),
          spaceWidgetColor(),
          //no.76
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: size_28_w),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                  LocaleKeys.report_observation_time_explanation.tr(),
                  value.msClassifications
                      .where((element) => element.ClassificationCD == '015')
                      .toList()
                      .map((e) => e.Value.toString())
                      .toList(),
                  value.onSelectObservationTimeExplanation1,
                  backgroundTextLabel: kColorDEE9F6);
            }),
          ),
        ]);
  }

  Widget buildLayout6() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //no.77
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                LocaleKeys.airway_management.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '007')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.onSelectAirwayManagement,
              );
            }),
          ),

          spaceWidgetColor(),

          //no.78
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.foreign_matter_removal.tr(),
                  yesNothings, value.onSelectForeignMatterRemoval);
            }),
          ),

          spaceWidgetColor(),

          //no.79
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                  LocaleKeys.suction.tr(), yesNothings, value.onSelectSuction);
            }),
          ),

          spaceWidgetColor(),

          //no.80
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.artificial_respiration.tr(),
                  yesNothings, value.onSelectArtificialRespiration);
            }),
          ),

          spaceWidgetColor(),

          //no.81
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.chest_compression.tr(),
                  yesNothings, value.onSelectChestCompression);
            }),
          ),

          spaceWidgetColor(),

          //no.82
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.ecg_monitor.tr(), yesNothings,
                  value.onSelectEcgMonitor);
            }),
          ),

          spaceWidgetColor(),

          //no.83 & 84
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: OutlineTextFormField(
                      keyboardType: TextInputType.number,
                      isAlwaysShowLable: true,
                      maxLength: 3,
                      counterWidget: unitWidget(LocaleKeys.unit_L.tr()),
                      counterStyle: counterStyle,
                      textColor: kColor4472C4,
                      colorBorder: Colors.black26,
                      colorFocusBorder: kColor4472C4,
                      labelText: LocaleKeys.o2_administration.tr(),
                      onChanged: (value) =>
                          inputReportViewModel.onChangeO2Administration(value),
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return timePicker(
                        LocaleKeys.o2_administration_time.tr(),
                        value.dtReport.O2AdministrationTime,
                        value.onSelectO2AdministrationTime);
                  }),
                  flex: 1,
                )
              ],
            ),
          ),

          spaceWidgetColor(height: size_6_w),

          //no.85
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                LocaleKeys.spinal_cord_motion_limitation.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '008')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.onSelectSpinalCordMotionLimitation,
              );
            }),
          ),
          spaceWidgetColor(),

          //no.86
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.hemostasis.tr(), yesNothings,
                  value.onSelectHemostasis);
            }),
          ),
          spaceWidgetColor(),

          //no.87
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.splint_fixation.tr(), yesNothings,
                  value.onSelectSplintFixation);
            }),
          ),
          spaceWidgetColor(),

          //no.88
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.coating_treatment.tr(),
                  yesNothings, value.onSelectCoatingTreatment);
            }),
          ),
          spaceWidgetColor(),

          //no.89
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.burn_treatment.tr(), yesNothings,
                  value.onSelectBurnTreatment);
            }),
          ),
          spaceWidgetColor(),

          //no.90 & 91
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: OutlineTextFormField(
                      keyboardType: TextInputType.number,
                      isAlwaysShowLable: true,
                      maxLength: 3,
                      counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                      counterStyle: counterStyle,
                      textColor: kColor4472C4,
                      colorBorder: Colors.black26,
                      colorFocusBorder: kColor4472C4,
                      labelText: LocaleKeys.bs_measurement_1.tr(),
                      onChanged: (value) =>
                          inputReportViewModel.onChangeBsMeasurement1(value),
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return timePicker(
                        LocaleKeys.bs_measurement_time_1.tr(),
                        value.dtReport.BSMeasurementTime1,
                        value.onSelectBsMeasurementTime1);
                  }),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),

          //no.92
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.puncture_site_1.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangePunctureSite1(value),
            ),
          ),

          //no.93 & 94
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: OutlineTextFormField(
                      keyboardType: TextInputType.number,
                      isAlwaysShowLable: true,
                      maxLength: 3,
                      counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                      counterStyle: counterStyle,
                      textColor: kColor4472C4,
                      colorBorder: Colors.black26,
                      colorFocusBorder: kColor4472C4,
                      labelText: LocaleKeys.bs_measurement_2.tr(),
                      onChanged: (value) =>
                          inputReportViewModel.onChangeBsMeasurement2(value),
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return timePicker(
                        LocaleKeys.bs_measurement_time_2.tr(),
                        value.dtReport.BSMeasurementTime2,
                        value.onSelectBsMeasurementTime2);
                  }),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),

          //no.95
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.puncture_site_2.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangePunctureSite2(value),
            ),
          ),

          spaceWidgetColor(),

          //no.96
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 60,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.others.tr(),
              onChanged: (value) => inputReportViewModel.onChangeOthers(value),
            ),
          ),

          spaceWidgetColor(height: size_20_w),
        ]);
  }

  Widget buildLayout7() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //no.54
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return timePicker(LocaleKeys.observation_time.tr(),
                  value.observationTime2, value.onConfirmObservationTime2);
            }),
          ),
          spaceWidgetColor(),
          //no.55
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                LocaleKeys.jcs.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '011')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.jcs2,
                value.onSelectJcs2,
              );
            }),
          ),
          spaceWidgetColor(),
          //no.57,58,59
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDownSearch(
                      LocaleKeys.gcs_e.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '012')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.gcsE2,
                      value.onSelectGcsE2,
                    );
                  }),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDownSearch(
                      LocaleKeys.gcs_v.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '013')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.gcsV2,
                      value.onSelectGcsV2,
                    );
                  }),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDownSearch(
                      LocaleKeys.gcs_m.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '014')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.gcsM2,
                      value.onSelectGcsM2,
                    );
                  }),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.60
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_times_minute.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.breathing.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBreathing2(value),
            ),
          ),
          spaceWidgetColor(),
          //no.61
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_times_minute.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.pulse.tr(),
              onChanged: (value) => inputReportViewModel.onChangePulse2(value),
            ),
          ),
          spaceWidgetColor(),
          //no.62 & 63
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.blood_pressure_up.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeBloodPressureUp2(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.blood_pressure_lower.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeBloodPressureLower2(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),
          //no.64 & 65
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_percent.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.spo2_percent.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeSpo2Percent2(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_L.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.spo2_l.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeSpo2L2(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),
          //no.66 & 67
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mm.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.right_pupil.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeRightPupil2(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mm.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.left_pupil.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeLeftPupil2(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.68
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.light_reflection_right.tr(),
                  yesNothings, value.onSelectLightReflectionRight2);
            }),
          ),
          spaceWidgetColor(),
          //no.69
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.light_reflection_left.tr(),
                  yesNothings, value.onSelectLightReflectionLeft2);
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.70
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_C.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.body_temperature.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBodyTemperature2(value),
            ),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.71
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                LocaleKeys.facial_features.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '005')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.facialFeatures2,
                value.onSelectFacialFeatures2,
              );
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.72
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.bleeding.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBleeding2(value),
            ),
          ),
          spaceWidgetColor(
            height: size_6_w,
          ),
          //no.73
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                  LocaleKeys.incontinence.tr(),
                  value.msClassification006s
                      .map((e) => e.Value.toString())
                      .toList(),
                  value.onSelectIncontinence2);
            }),
          ),
          spaceWidgetColor(),
          //no.74
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.vomiting.tr(), yesNothings,
                  value.onSelectVomiting2);
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.75
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.limb.tr(),
              onChanged: (value) => inputReportViewModel.onChangeLimb2(value),
            ),
          ),
          spaceWidgetColor(),
          //no.76
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: size_28_w),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                LocaleKeys.report_observation_time_explanation.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '015')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.onSelectObservationTimeExplanation2,
                backgroundTextLabel: kColorDEE9F6,
              );
            }),
          ),
        ]);
  }

  Widget buildLayout8() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //no.54
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return timePicker(LocaleKeys.observation_time.tr(),
                  value.observationTime3, value.onConfirmObservationTime3);
            }),
          ),
          spaceWidgetColor(),
          //no.55
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                LocaleKeys.jcs.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '011')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.jcs3,
                value.onSelectJcs3,
              );
            }),
          ),
          spaceWidgetColor(),
          //no.57,58,59
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDownSearch(
                      LocaleKeys.gcs_e.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '012')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.gcsE3,
                      value.onSelectGcsE3,
                    );
                  }),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDownSearch(
                      LocaleKeys.gcs_v.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '013')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.gcsV3,
                      value.onSelectGcsV3,
                    );
                  }),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Consumer<InputReportViewModel>(
                      builder: (context, value, child) {
                    return buildDropDownSearch(
                      LocaleKeys.gcs_m.tr(),
                      value.msClassifications
                          .where((element) => element.ClassificationCD == '014')
                          .toList()
                          .map((e) => e.Value.toString())
                          .toList(),
                      value.gcsM3,
                      value.onSelectGcsM3,
                    );
                  }),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.60
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_times_minute.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.breathing.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBreathing3(value),
            ),
          ),
          spaceWidgetColor(),
          //no.61
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_times_minute.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.pulse.tr(),
              onChanged: (value) => inputReportViewModel.onChangePulse3(value),
            ),
          ),
          spaceWidgetColor(),
          //no.62 & 63
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.blood_pressure_up.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeBloodPressureUp3(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mmHg.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.blood_pressure_lower.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeBloodPressureLower3(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),
          //no.64 & 65
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_percent.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.spo2_percent.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeSpo2Percent3(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_L.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.spo2_l.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeSpo2L3(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(),
          //no.66 & 67
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mm.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.right_pupil.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeRightPupil3(value),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: OutlineTextFormField(
                    keyboardType: TextInputType.number,
                    isAlwaysShowLable: true,
                    maxLength: 3,
                    counterWidget: unitWidget(LocaleKeys.unit_mm.tr()),
                    counterStyle: counterStyle,
                    textColor: kColor4472C4,
                    colorBorder: Colors.black26,
                    colorFocusBorder: kColor4472C4,
                    labelText: LocaleKeys.left_pupil.tr(),
                    onChanged: (value) =>
                        inputReportViewModel.onChangeLeftPupil3(value),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.68
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.light_reflection_right.tr(),
                  yesNothings, value.onSelectLightReflectionRight3);
            }),
          ),
          spaceWidgetColor(),
          //no.69
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.light_reflection_left.tr(),
                  yesNothings, value.onSelectLightReflectionLeft3);
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.70
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 3,
              counterWidget: unitWidget(LocaleKeys.unit_C.tr()),
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.body_temperature.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBodyTemperature3(value),
            ),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.71
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                LocaleKeys.facial_features.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '005')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.facialFeatures3,
                value.onSelectFacialFeatures3,
              );
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.72
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.bleeding.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeBleeding3(value),
            ),
          ),
          spaceWidgetColor(
            height: size_6_w,
          ),
          //no.73
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                  LocaleKeys.incontinence.tr(),
                  value.msClassification006s
                      .map((e) => e.Value.toString())
                      .toList(),
                  value.onSelectIncontinence3);
            }),
          ),
          spaceWidgetColor(),
          //no.74
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.vomiting.tr(), yesNothings,
                  value.onSelectVomiting3);
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.75
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 10,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.limb.tr(),
              onChanged: (value) => inputReportViewModel.onChangeLimb3(value),
            ),
          ),
          spaceWidgetColor(),
          //no.76
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: size_28_w),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                  LocaleKeys.report_observation_time_explanation.tr(),
                  value.msClassifications
                      .where((element) => element.ClassificationCD == '015')
                      .toList()
                      .map((e) => e.Value.toString())
                      .toList(),
                  value.onSelectObservationTimeExplanation3,
                  backgroundTextLabel: kColorDEE9F6);
            }),
          ),
        ]);
  }

  Widget buildLayout9() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //no.102
          OutlineTextFormField(
            isAlwaysShowLable: true,
            keyboardType: TextInputType.text,
            maxLength: 20,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.perceiver.tr(),
            onChanged: (value) => inputReportViewModel.onChangePerceiver(value),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.103
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                LocaleKeys.awareness_type.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '009')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.onSelectAwarenessType,
                backgroundTextLabel: kColorDEE9F6,
              );
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.104
          OutlineTextFormField(
            isAlwaysShowLable: true,
            keyboardType: TextInputType.text,
            maxLength: 20,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.whistleblower.tr(),
            onChanged: (value) =>
                inputReportViewModel.onChangeWhistleblower(value),
          ),
          spaceWidgetColor(),
          //no.105
          OutlineTextFormField(
            keyboardType: TextInputType.phone,
            isAlwaysShowLable: true,
            maxLength: 20,
            inputformatter: [
              FilteringTextInputFormatter.allow(allowPhoneNumber),
            ],
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.reporting_phone.tr(),
            onChanged: (value) =>
                inputReportViewModel.onChangeReportingPhone(value),
          ),
          spaceWidgetColor(),
        ],
      ),
    );
  }

  Widget buildLayout10() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //no.107
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearchObject(
                  LocaleKeys.transportation_medical_institution.tr(),
                  value.msHospitals
                      .map((e) => ObjectSearch(CD: e.HospitalCD, Name: e.Name))
                      .toList(),
                  value.transportationMedicalInstitution,
                  value.onSelectTransportationMedicalInstitution,
                  backgroundTextLabel: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(),
          //no.108
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearchObject(
                  LocaleKeys.forwarding_medical_institution.tr(),
                  value.msHospitals
                      .map((e) => ObjectSearch(CD: e.HospitalCD, Name: e.Name))
                      .toList(),
                  value.forwardingMedicalInstitution,
                  value.onSelectForwardingMedicalInstitution,
                  backgroundTextLabel: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(),

          //no.109
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return timePicker(
                  LocaleKeys.transfer_source_pick_up_time.tr(),
                  value.dtReport.TransferSourceReceivingTime,
                  value.onConfirmTransferSourcePickUpTime,
                  backgroundLableColor: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(height: size_22_w),
          //no.110
          OutlineTextFormField(
            keyboardType: TextInputType.text,
            isAlwaysShowLable: true,
            maxLength: 60,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.transfer_reason.tr(),
            onChanged: (value) =>
                inputReportViewModel.onChangeTransferReason(value),
          ),
          spaceWidgetColor(),
          //no.111
          OutlineTextFormField(
            keyboardType: TextInputType.text,
            isAlwaysShowLable: true,
            maxLength: 100,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.reason_for_non_delivery.tr(),
            onChanged: (value) =>
                inputReportViewModel.onChangeReasonForNonDelivery(value),
          ),
          spaceWidgetColor(height: size_6_w),
          //no.112
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(
                  LocaleKeys.transport_refusal_processing_record.tr(),
                  yesNothings,
                  value.onSelectTransportRefusalProcessingRecord,
                  backgroundTextLabel: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(height: size_28_w),
        ],
      ),
    );
  }

  Widget buildLayout11() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //no.114
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearchObject(
                  LocaleKeys.reporter_s_name.tr(),
                  value.msTeamMembers
                      .map(
                          (e) => ObjectSearch(CD: e.TeamMemberCD, Name: e.Name))
                      .toList(),
                  value.reportersName,
                  value.onSelectReportersName,
                  backgroundTextLabel: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(),
          //No.115
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return textShowWithLabel(LocaleKeys.reporter_s_affiliation.tr(),
                  value.reportersAffiliation ?? '',
                  backgroundLableColor: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(),
          //No.116
          Container(
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return textShowWithLabel(LocaleKeys.reporting_class.tr(),
                  value.reportersAffiliation ?? '',
                  backgroundLableColor: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(height: size_28_w),
        ],
      ),
    );
  }

  Widget buildLayout12() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //No.118
            OutlineTextFormField(
              keyboardType: TextInputType.text,
              isAlwaysShowLable: true,
              maxLength: 500,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.overview_of_the_outbreak.tr(),
              onChanged: (value) =>
                  inputReportViewModel.onChangeOverviewOfTheOutbreak(value),
            ),
            spaceWidgetColor(),
            //No.119
            OutlineTextFormField(
              keyboardType: TextInputType.text,
              isAlwaysShowLable: true,
              maxLength: 180,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.remarks.tr(),
              onChanged: (value) => inputReportViewModel.onChangeRemars(value),
            ),
            spaceWidgetColor(height: size_20_w),
          ]),
    );
  }

  final divider = Container(
    color: Colors.black26,
    height: 1,
  );

  Widget datePicker(
      String label, String? text, Function(DateTime date) onConfirm,
      {DateTime? maxDate, DateTime? minDate, Color? backgroundLableColor}) {
    DateTime? currentDate = Utils.stringToDateTime(text, format: yyyy_MM_dd_);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: InkWell(
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(text ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: kColor4472C4,
                              fontWeight: FontWeight.normal,
                              fontSize: text_16)),
                    ),
                  ],
                ),
              ),
              onTap: () => {
                    Utils.removeFocus(context),
                    DatePicker.showDatePicker(
                      context,
                      maxTime: maxDate,
                      minTime: minDate,
                      showTitleActions: true,
                      locale: localeTypeJP,
                      onChanged: (date) {
                        //print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                      },
                      onConfirm: (date) => onConfirm(date),
                      currentTime: currentDate ?? DateTime.now(),
                    ),
                  }),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          color: backgroundLableColor ?? Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }

  Widget textShowWithLabel(String label, String? text,
      {Color? backgroundLableColor}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.black38,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(text ?? '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: kColor4472C4,
                          fontWeight: FontWeight.normal,
                          fontSize: text_16)),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          color: backgroundLableColor ?? Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }

  Widget timePicker(
      String label, String? text, Function(DateTime date) onConfirm,
      {Color? backgroundLableColor, bool? showSecondCol = false}) {
    DateTime? currentTime = Utils.stringToDateTime(text, format: HH_mm_);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: InkWell(
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(text ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: kColor4472C4,
                              fontWeight: FontWeight.normal,
                              fontSize: text_16)),
                    ),
                  ],
                ),
              ),
              onTap: () => {
                    Utils.removeFocus(context),
                    DatePicker.showTimePicker(
                      context,
                      showTitleActions: true,
                      locale: localeTypeJP,
                      showSecondsColumn: showSecondCol ?? false,
                      onChanged: (date) {
                        //print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                      },
                      onConfirm: (date) => onConfirm(date),
                      currentTime: currentTime ?? DateTime.now(),
                    ),
                  }),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          color: backgroundLableColor ?? Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }

  Widget spaceWidgetColor({double? height, Color? color}) {
    return Container(
      color: color ?? transparent,
      height: height ?? size_12_h,
    );
  }

  final counterStyle = TextStyle(color: Colors.black);

  Widget? unitWidget(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: text_10,
        color: kColor4472C4,
      ),
    );
  }

  Widget buildDropDown(String label, List<String> list,
      Function(String? itemSelected) onSelected,
      {Color? backgroundTextLabel}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: DropdownButtonFormField2(
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: kColor4472C4),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              //Add isDense true and zero Padding.
              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              //Add more decoration as you want here
              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
            ),
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 30,
            buttonHeight: 54,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            items: list
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: text_16, color: kColor4472C4),
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? value) => onSelected(value),
          ),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          color: backgroundTextLabel ?? Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }

  Widget buildDropDownSearch(String label, List<String> list,
      String? valueSelect, Function(String? itemSelected) onSelected,
      {Color? backgroundTextLabel, double? height}) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownSearch<String>(
                popupProps: PopupProps.menu(showSearchBox: true),
                items: list,
                onChanged: (value) {
                  setState(() {
                    valueSelect = value;
                  });
                  onSelected(valueSelect);
                })),
        Container(
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          color: backgroundTextLabel ?? Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }

  Widget buildDropDownSearchObject(String label, List<ObjectSearch> list,
      String? valueSelect, Function(String? itemSelected) onSelected,
      {Color? backgroundTextLabel, double? height}) {
    print(valueSelect);
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownSearch<ObjectSearch>(
                popupProps: PopupProps.menu(showSearchBox: true),
                items: list,
                itemAsString: ((item) => item.Name),
                filterFn: ((item, filter) =>
                    item.Name.toString().contains(filter)),
                onChanged: (e) {
                  setState(() {
                    valueSelect = '${e?.CD} ${e?.Name}';
                  });
                  onSelected(valueSelect);
                })),
        Container(
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          color: backgroundTextLabel ?? Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }

  Widget buildCheckbox(String label, List<String> list,
      Function(List<String> checkeds) onSelecteds) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            padding: EdgeInsets.only(top: size_14_w),
            height: size_200_w,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.black38,
              ),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: CheckboxGroup(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              labels: list,
              onSelected: (List<String> checkedString) =>
                  onSelecteds(checkedString),
            ),
          ),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
      ],
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.headerValue,
    this.isExpanded = false,
  });

  String headerValue;
  bool isExpanded;
}
