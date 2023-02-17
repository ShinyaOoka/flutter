import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:mobx/mobx.dart';

class RemarksSection extends StatefulWidget {
  final Report report;
  final bool readOnly;

  RemarksSection({super.key, required this.report, this.readOnly = false});

  @override
  State<RemarksSection> createState() => _RemarksSectionState();
}

class _RemarksSectionState extends State<RemarksSection>
    with ReportSectionMixin {
  final summaryOfOccurrenceController = TextEditingController();
  final remarksController = TextEditingController();
  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    reactionDisposer = autorun((_) {
      syncControllerValue(
          summaryOfOccurrenceController, widget.report.summaryOfOccurrence);
      syncControllerValue(remarksController, widget.report.remarks);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    summaryOfOccurrenceController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(widget.report),
        _buildLine2(widget.report),
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
