import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/app_date_picker.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class ReporterSection extends StatefulWidget {
  final bool readOnly;

  const ReporterSection({super.key, this.readOnly = false});

  @override
  State<ReporterSection> createState() => _ReporterSectionState();
}

class _ReporterSectionState extends State<ReporterSection>
    with ReportSectionMixin {
  late ReportStore reportStore;
  final nameOfReporterController = TextEditingController();
  final affiliationOfReporterController = TextEditingController();
  final positionOfReporterController = TextEditingController();
  final approver1Controller = TextEditingController();
  final approver2Controller = TextEditingController();
  final approver3Controller = TextEditingController();

  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(nameOfReporterController,
          reportStore.selectingReport!.nameOfReporter);
      syncControllerValue(affiliationOfReporterController,
          reportStore.selectingReport!.affiliationOfReporter);
      syncControllerValue(positionOfReporterController,
          reportStore.selectingReport!.positionOfReporter);
      syncControllerValue(
          approver1Controller, reportStore.selectingReport!.approver1);
      syncControllerValue(
          approver2Controller, reportStore.selectingReport!.approver2);
      syncControllerValue(
          approver3Controller, reportStore.selectingReport!.approver3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLine1(reportStore.selectingReport!),
          _buildLine2(reportStore.selectingReport!),
          _buildLine3(reportStore.selectingReport!),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return lineLayout(children: [
      AppTextField(
        controller: nameOfReporterController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        label: 'name_of_reporter'.i18n(),
        onChanged: (value) => report.nameOfReporter = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        optional: true,
      ),
      AppTextField(
        controller: affiliationOfReporterController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        label: 'affiliation_of_reporter'.i18n(),
        onChanged: (value) => report.affiliationOfReporter = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        optional: true,
      ),
    ]);
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd == AppConstants.positionOfReporterCode)
            .toList(),
        label: 'position_of_reporter'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.positionOfReporterType = value,
        selectedItem: report.positionOfReporterType,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
        optional: true,
      ),
      AppDatePicker(
        label: 'date_of_emergency_report'.i18n(),
        selectedDate: report.dateOfEmergencyReport,
        onChanged: (date) {
          report.dateOfEmergencyReport = date;
        },
        maxTime: DateTime.now(),
        readOnly: widget.readOnly,
        defaultDate: DateTime.now(),
        optional: true,
      ),
    ]);
  }

  Widget _buildLine3(Report report) {
    return lineLayout(children: [
      AppTextField(
        controller: approver1Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        label: 'approver_1'.i18n(),
        onChanged: (value) => report.approver1 = value,
        maxLength: 5,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        optional: true,
      ),
      AppTextField(
        controller: approver2Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        label: 'approver_2'.i18n(),
        onChanged: (value) => report.approver2 = value,
        maxLength: 5,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        optional: true,
      ),
      AppTextField(
        controller: approver3Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        label: 'approver_3'.i18n(),
        onChanged: (value) => report.approver3 = value,
        maxLength: 5,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        optional: true,
      ),
    ]);
  }
}
