// ignore_for_file: body_might_complete_normally_nullable

import 'package:ak_azm_flutter/app/module/common/toast_util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:tap_canvas/tap_canvas.dart';

import '../../../generated/locale_keys.g.dart';
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
  late AnimationController _animationController;
  final List<Item> data = [];

  @override
  void initState() {
    data.add(Item(headerValue: LocaleKeys.participation_information.tr()));
    data.add(Item(headerValue: LocaleKeys.victim_information.tr()));
    data.add(Item(headerValue: LocaleKeys.time_elapsed.tr()));
    data.add(Item(headerValue: LocaleKeys.occurrence_status.tr()));
    data.add(Item(headerValue: LocaleKeys.vital_signs_appearance_1.tr()));
    data.add(Item(headerValue: LocaleKeys.treatment.tr()));
    data.add(Item(headerValue: LocaleKeys.vital_signs_appearance_2.tr()));
    data.add(Item(headerValue: LocaleKeys.vital_signs_appearance_3.tr()));
    data.add(Item(headerValue: LocaleKeys.reporting_information.tr()));
    data.add(Item(headerValue: LocaleKeys.delivery_information.tr()));
    inputReportViewModel.initData();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    inputReportViewModel.serverFC.dispose();
    inputReportViewModel.portFC.dispose();
    _animationController.dispose();
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
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: TextButton(
              child: Text(LocaleKeys.back_report.tr(),
                  // style: Theme.of(context).appBarTheme.titleTextStyle,
                  style: TextStyle(
                    fontSize: 16,
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
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () => {ToastUtil.showToast('Save Button')},
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
          backgroundColor:
              indexLayout == 9 || indexLayout == 10 ? kColorDEE9F6 : null,
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
        return buildLayout_1();

      case 2:
        return buildLayout_2();

      case 3:
        return buildLayout_1();

      case 4:
        return buildLayout_1();

      case 5:
        return buildLayout_1();

      case 6:
        return buildLayout_1();

      case 7:
        return buildLayout_1();

      case 8:
        return buildLayout_1();

      case 9:
        return buildLayout_9();

      case 10:
        return buildLayout_10();
      default:
        return Container();
    }
  }

  Widget buildLayout_1() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //example set max length & unit for text field
          /*Container(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.ambulance_name.tr(),
                        onChanged: (value) => {},
                      ),
                    ),
                    spaceWidget,
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 13,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.ambulance_tel.tr(),
                        onChanged: (value) => {},
                      ),
                    ),
                    spaceWidget,
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: OutlineTextFormField(
                        keyboardType: TextInputType.number,
                        isAlwaysShowLable: true,
                        maxLength: 20,
                        counterWidget: unitWidget('単位名'),
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.captain_name.tr(),
                        onChanged: (value) => {},
                      ),
                    ),
                    SizedBox(
                      height: size_8_h,
                    ),*/

          //No.2
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                  LocaleKeys.ambulance_name.tr(),
                  value.msTeams.map((e) => e.Name.toString()).toList(),
                  value.ambulanceName,
                  value.onSelectAmbulanceName);
            }),
          ),
          spaceWidgetColor(),

          //No.3
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: IgnorePointer(
              ignoring: true,
              child: Consumer<InputReportViewModel>(
                  builder: (context, value, child) {
                return OutlineTextFormField(
                  keyboardType: TextInputType.number,
                  isAlwaysShowLable: true,
                  controller: TextEditingController(text: value.ambulanceTel),
                  counterWidget: null,
                  textColor: kColor4472C4,
                  colorBorder: Colors.black26,
                  colorFocusBorder: kColor4472C4,
                  labelText: LocaleKeys.ambulance_tel.tr(),
                  onChanged: (value) => {},
                );
              }),
            ),
          ),

          spaceWidgetColor(),

          //No.4
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                  LocaleKeys.captain_name.tr(),
                  value.msTeamMembers.map((e) => e.Name.toString()).toList(),
                  value.captainName,
                  value.onSelectCaptainName);
            }),
          ),

          spaceWidgetColor(),

          //No.5
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.emt_qualification.tr(),
                  value.yesNothings, value.onSelectQualification);
            }),
          ),
          spaceWidgetColor(),

          //No.6
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDown(LocaleKeys.emt_ride.tr(), value.yesNothings,
                  value.onSelectRide);
            }),
          ),
          spaceWidgetColor(),

          //No.7
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                  LocaleKeys.report_member_name.tr(),
                  value.msTeamMembers.map((e) => e.Name.toString()).toList(),
                  value.reportMemberName,
                  value.onSelectReportMemberName,
                  backgroundTextLabel: kColorDEE9F6);
            }),
          ),
          spaceWidgetColor(color: kColorDEE9F6),
          //No.8
          Container(
              color: kColorDEE9F6,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Consumer<InputReportViewModel>(
                  builder: (context, value, child) {
                return buildDropDownSearch(
                    LocaleKeys.report_name_of_engineer.tr(),
                    value.msTeamMembers.map((e) => e.Name.toString()).toList(),
                    value.reportNameOfEngineer,
                    value.onSelectReportNameOfEngineer,
                    backgroundTextLabel: kColorDEE9F6);
              })),

          spaceWidgetColor(color: kColorDEE9F6),
          //No.9
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 6,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.report_cumulative_total.tr(),
              onChanged: (value) => {},
            ),
          ),

          //spaceWidget,
          spaceWidgetColor(color: kColorDEE9F6),

          //No.10
          Container(
            color: kColorDEE9F6,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: OutlineTextFormField(
              keyboardType: TextInputType.number,
              isAlwaysShowLable: true,
              maxLength: 6,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.report_team.tr(),
              onChanged: (value) => {},
            ),
          ),
        ]);
  }

  Widget buildLayout_2() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //example set max length & unit for text field
          /*Container(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.ambulance_name.tr(),
                        onChanged: (value) => {},
                      ),
                    ),
                    spaceWidget,
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: OutlineTextFormField(
                        isAlwaysShowLable: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 13,
                        counterStyle: counterStyle,
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.ambulance_tel.tr(),
                        onChanged: (value) => {},
                      ),
                    ),
                    spaceWidget,
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: OutlineTextFormField(
                        keyboardType: TextInputType.number,
                        isAlwaysShowLable: true,
                        maxLength: 20,
                        counterWidget: unitWidget('単位名'),
                        textColor: kColor4472C4,
                        colorBorder: Colors.black26,
                        colorFocusBorder: kColor4472C4,
                        labelText: LocaleKeys.captain_name.tr(),
                        onChanged: (value) => {},
                      ),
                    ),
                    SizedBox(
                      height: size_8_h,
                    ),*/

          //no.12
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.family_name.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.13
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.furigana.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.14
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
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(height: size_6_w),

          //No.15
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                LocaleKeys.sex.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '001')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.sex,
                value.onSelectAmbulanceName,
                height: 220,
              );
            }),
          ),
          spaceWidgetColor(height: size_18_w),

          //no.16
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return datePicker(LocaleKeys.birthday.tr(), value.birthday,
                  value.onConfirmData);
            }),
          ),

          spaceWidgetColor(height: size_28_w),
          //no.17
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.tel.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.18
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.family_phone.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.19
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.medical_history.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.20
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.medical_history_medical_institution.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.21
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.family.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(height: size_6_w),

          //no.22
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Consumer<InputReportViewModel>(
                builder: (context, value, child) {
              return buildDropDownSearch(
                LocaleKeys.dosage.tr(),
                value.msClassifications
                    .where((element) => element.ClassificationCD == '010')
                    .toList()
                    .map((e) => e.Value.toString())
                    .toList(),
                value.captainName,
                value.onSelectCaptainName,
                height: 220,
              );
            }),
          ),
          spaceWidgetColor(height: size_28_w),

          //no.23
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.dosing_details.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.24
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.text,
              maxLength: 20,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.allergy.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.25
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
              labelText: LocaleKeys.report_name_of_injury_or_disease.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.26
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
              labelText: LocaleKeys.report_degree.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),

          //no.27
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: OutlineTextFormField(
              isAlwaysShowLable: true,
              keyboardType: TextInputType.number,
              maxLength: 3,
              counterStyle: counterStyle,
              textColor: kColor4472C4,
              colorBorder: Colors.black26,
              colorFocusBorder: kColor4472C4,
              labelText: LocaleKeys.report_age.tr(),
              onChanged: (value) => {},
            ),
          ),
          spaceWidgetColor(),
        ]);
  }

  Widget buildLayout_9() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlineTextFormField(
            isAlwaysShowLable: true,
            keyboardType: TextInputType.text,
            maxLength: 20,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.ambulance_name.tr(),
            onChanged: (value) => {},
          ),
          spaceWidgetColor(),
          OutlineTextFormField(
            isAlwaysShowLable: true,
            keyboardType: TextInputType.phone,
            maxLength: 13,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.ambulance_tel.tr(),
            onChanged: (value) => {},
          ),
          spaceWidgetColor(),
          OutlineTextFormField(
            keyboardType: TextInputType.number,
            isAlwaysShowLable: true,
            maxLength: 20,
            counterWidget: unitWidget('単位名'),
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.captain_name.tr(),
            onChanged: (value) => {},
          ),
          spaceWidgetColor(),
        ],
      ),
    );
  }

  Widget buildLayout_10() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlineTextFormField(
            isAlwaysShowLable: true,
            keyboardType: TextInputType.text,
            maxLength: 20,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.ambulance_name.tr(),
            onChanged: (value) => {},
          ),
          spaceWidgetColor(),
          OutlineTextFormField(
            isAlwaysShowLable: true,
            keyboardType: TextInputType.phone,
            maxLength: 13,
            counterStyle: counterStyle,
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.ambulance_tel.tr(),
            onChanged: (value) => {},
          ),
          spaceWidgetColor(),
          OutlineTextFormField(
            keyboardType: TextInputType.number,
            isAlwaysShowLable: true,
            maxLength: 20,
            counterWidget: unitWidget('単位名'),
            textColor: kColor4472C4,
            colorBorder: Colors.black26,
            colorFocusBorder: kColor4472C4,
            labelText: LocaleKeys.captain_name.tr(),
            onChanged: (value) => {},
          ),
          spaceWidgetColor(),
        ],
      ),
    );
  }

  final divider = Container(
    color: Colors.black26,
    height: 1,
  );

  Widget datePicker(
      String label, String? text, Function(DateTime date) onConfirm) {
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
              onTap: () => DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  onChanged: (date) {
                    //print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                  },
                  onConfirm: (date) => onConfirm(date),
                  currentTime: DateTime.now())),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.black.withOpacity(0.6), fontSize: text_12),
          ),
          color: Colors.white,
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
      Function(String? itemSelected) onSelected) {
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
            buttonPadding: const EdgeInsets.only(left: 10, right: 10),
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
            style: TextStyle(
                color: Colors.black.withOpacity(0.6), fontSize: text_12),
          ),
          color: Colors.white,
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
            child: SearchChoices.single(
              autofocus: false,
              closeButton: null,
              fieldDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black38,
                ),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              displayClearIcon: false,
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 30,
                color: Colors.black38,
              ),
              items: list.map<DropdownMenuItem>((string) {
                return (DropdownMenuItem(
                  value: string,
                  child: Text(
                    string,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: text_16, color: kColor4472C4),
                  ),
                ));
              }).toList(),
              value: valueSelect,
              hint: '',
              searchHint: null,
              onChanged: (value) {
                setState(() {
                  valueSelect = value;
                });
                onSelected(valueSelect);
              },
              dialogBox: false,
              isExpanded: true,
              menuConstraints:
                  BoxConstraints.tight(Size.fromHeight(height ?? 300)),
            )),
        Container(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.black.withOpacity(0.6), fontSize: text_12),
          ),
          color: backgroundTextLabel ?? Colors.white,
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
