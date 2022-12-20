import 'package:ak_azm_flutter/app/module/common/toast_util.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                onPressed: () => {ToastUtil.showToast('Sign up Button')},
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          transparentStatusBar: 0.0,
          title: LocaleKeys.server_config.tr(),
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
        return indexLayout == 9 || indexLayout == 10
            ? ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: kColorDEE9F6,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text('$indexLayout. ${item.headerValue}'),
                  );
                },
                body: Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
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
                ),
                isExpanded: item.isExpanded,
              )
            : ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text('$indexLayout. ${item.headerValue}'),
                  );
                },
                body: Container(
                  child: Column(
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
                              value.msTeams
                                  .map((e) => e.Name.toString())
                                  .toList(),
                              value.ambulanceName,
                              value.onSelectAmbulanceName);
                        }),
                      ),
                      spaceWidgetColor(),

                      //No.3
                      Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16
                        ),
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
                              value.msTeamMembers
                                  .map((e) => e.Name.toString())
                                  .toList(),
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
                          return buildDropDown(
                              LocaleKeys.emt_qualification.tr(),
                              value.yesNothings,
                              value.onSelectQualification);
                        }),
                      ),
                      spaceWidgetColor(),

                      //No.6
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Consumer<InputReportViewModel>(
                            builder: (context, value, child) {
                          return buildDropDown(LocaleKeys.emt_ride.tr(),
                              value.yesNothings, value.onSelectRide);
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
                              value.msTeamMembers
                                  .map((e) => e.Name.toString())
                                  .toList(),
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
                                value.msTeamMembers
                                    .map((e) => e.Name.toString())
                                    .toList(),
                                value.reportNameOfEngineer,
                                value.onSelectReportNameOfEngineer,
                                backgroundTextLabel: kColorDEE9F6);
                          })),

                      spaceWidgetColor(color: kColorDEE9F6),
                      //No.9
                      Container(
                        color: kColorDEE9F6,
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
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
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                    ],
                  ),
                ),
                isExpanded: item.isExpanded,
              );
      }).toList(),
    );
  }

  final divider = Container(
    color: Colors.black26,
    height: 1,
  );

  Widget spaceWidgetColor({Color? color}) {
    return Container(
      color: color ?? transparent,
      height: size_12_h,
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
            buttonHeight: 60,
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
                      style: TextStyle(
                        fontSize: text_16,
                        color: kColor4472C4
                      ),
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
      {Color? backgroundTextLabel}) {
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
                    style: TextStyle(
                      fontSize: text_16,
                        color: kColor4472C4
                    ),
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
              menuConstraints: BoxConstraints.tight(const Size.fromHeight(300)),
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
