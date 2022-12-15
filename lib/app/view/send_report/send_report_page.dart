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
import '../widget_utils/expansion_panel_custom.dart';
import '../widget_utils/outline_text_form_field.dart';
import 'send_report_viewmodel.dart';

class SendReportPage extends PageProvideNode<SendReportViewModel> {
  SendReportPage() : super();

  @override
  Widget buildContent(BuildContext context) {
    return InputReportContent(viewModel);
  }
}

class InputReportContent extends StatefulWidget {
  final SendReportViewModel _inputReportViewModel;

  InputReportContent(this._inputReportViewModel);

  @override
  InputReportState createState() => InputReportState();
}

class InputReportState extends LifecycleState<InputReportContent>
    with SingleTickerProviderStateMixin {
  SendReportViewModel get inputReportViewModel => widget._inputReportViewModel;
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
    return
      WillPopScope(
          onWillPop: () => inputReportViewModel.back(),
          child: BaseScaffoldSafeArea(
            customAppBar: AppBar(
              backgroundColor: kColor4472C4,
              centerTitle: true,
              title: Text(
                'SEND REPORT',
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
                  child: Text('List',
                      // style: Theme.of(context).appBarTheme.titleTextStyle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      )),
                  onPressed: () => inputReportViewModel.openListReport(),
                ),
              ],
              automaticallyImplyLeading: false,
            ),
            transparentStatusBar: 0.0,
            title: LocaleKeys.server_config.tr(),
            hideBackButton: false,
            /*body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        LocaleKeys.x_series_data_acquisition.tr(),
                        // style: Theme.of(context).appBarTheme.titleTextStyle,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    color: kColor4472C4,
                    width: double.infinity,
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: _buildPanel(),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
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
                      spaceWidget,
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
                      spaceWidget,
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
                      spaceWidget,
                    ],
                  ),
                ),
                isExpanded: item.isExpanded,
              )
            : ExpansionPanel(
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
                      spaceWidget,
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
                      spaceWidget,
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
                      SizedBox(
                        height: size_8_h,
                      ),
                      Consumer<SendReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(LocaleKeys.emt_qualification.tr(),
                            value.yesNothings, value.onSelectQualification);
                      }),
                      spaceWidget,
                      Consumer<SendReportViewModel>(
                          builder: (context, value, child) {
                        return buildDropDown(LocaleKeys.emt_ride.tr(),
                            value.yesNothings, value.onSelectRide);
                      }),
                      spaceWidget,
                    ],
                  ),
                ),
                isExpanded: item.isExpanded,
              );
      }).toList(),
    );
  }

  final spaceWidget = SizedBox(
    height: size_12_h,
  );
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
                      style: TextStyle(
                        fontSize: text_16,
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
