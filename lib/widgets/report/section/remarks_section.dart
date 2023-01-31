import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class RemarksSection extends StatelessWidget with ReportSectionMixin {
  final Report report;

  RemarksSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(report),
        _buildLine2(report),
      ],
    );
  }

  Widget _buildLine1(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'summary_of_occurrence'.i18n(),
        onChanged: (value) => report.summaryOfOccurrence = value,
        maxLength: 500,
        minLines: 3,
      ),
    ]);
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'remarks'.i18n(),
        onChanged: (value) => report.remarks = value,
        maxLength: 180,
        minLines: 3,
      ),
    ]);
  }
}
