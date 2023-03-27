import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:mobx/mobx.dart';

class RemarksSection extends StatefulWidget {
  final bool readOnly;

  const RemarksSection({super.key, this.readOnly = false});

  @override
  State<RemarksSection> createState() => _RemarksSectionState();
}

class _RemarksSectionState extends State<RemarksSection>
    with ReportSectionMixin {
  final summaryOfOccurrenceController = TextEditingController();
  final summaryOfOccurrenceScrollController = ScrollController();
  final remarksController = TextEditingController();
  final remarksScrollController = ScrollController();
  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(summaryOfOccurrenceController,
          reportStore.selectingReport!.summaryOfOccurrence);
      syncControllerValue(
          remarksController, reportStore.selectingReport!.remarks);
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
    return Observer(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLine1(reportStore.selectingReport!),
          _buildLine2(reportStore.selectingReport!),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return lineLayout(children: [
      Scrollbar(
        controller: summaryOfOccurrenceScrollController,
        thumbVisibility: true,
        child: AppTextField(
          label: 'summary_of_occurrence'.i18n(),
          controller: summaryOfOccurrenceController,
          scrollController: summaryOfOccurrenceScrollController,
          inputFormatters: [maxLineFormatter(9)],
          onChanged: (value) => report.summaryOfOccurrence = value,
          maxLength: 500,
          minLines: 3,
          maxLines: 3,
          readOnly: widget.readOnly,
          optional: true,
        ),
      ),
    ]);
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      Scrollbar(
        controller: remarksScrollController,
        thumbVisibility: true,
        child: AppTextField(
          label: 'remarks'.i18n(),
          controller: remarksController,
          scrollController: remarksScrollController,
          inputFormatters: [maxLineFormatter(3)],
          onChanged: (value) => report.remarks = value,
          maxLength: 180,
          minLines: 3,
          maxLines: 3,
          readOnly: widget.readOnly,
        ),
      ),
    ]);
  }
}
