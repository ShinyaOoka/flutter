import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_date_picker.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class OccurrenceStatusSection extends StatefulWidget {
  final bool readOnly;

  const OccurrenceStatusSection({super.key, this.readOnly = false});

  @override
  State<OccurrenceStatusSection> createState() =>
      _OccurrenceStatusSectionState();
}

class _OccurrenceStatusSectionState extends State<OccurrenceStatusSection>
    with ReportSectionMixin {
  final placeOfIncidentController = TextEditingController();
  final placeOfDispatchController = TextEditingController();
  final accidentSummaryController = TextEditingController();

  final accidentSummaryScrollController = ScrollController();
  final placeOfIncidentScrollController = ScrollController();

  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(placeOfIncidentController,
          reportStore.selectingReport!.placeOfIncident);
      syncControllerValue(accidentSummaryController,
          reportStore.selectingReport!.accidentSummary);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    placeOfIncidentController.dispose();
    placeOfDispatchController.dispose();
    accidentSummaryController.dispose();
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
          _buildLine4(reportStore.selectingReport!),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        showSearchBox: true,
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd == AppConstants.typeOfAccidentCode)
            .toList(),
        label: 'type_of_accident'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.accidentType = value,
        selectedItem: report.accidentType,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
      ),
      Row(
        children: [
          Expanded(
            child: AppDatePicker(
              label: 'date_of_occurence'.i18n(),
              selectedDate: report.dateOfOccurrence,
              onChanged: (date) => report.dateOfOccurrence = date,
              readOnly: widget.readOnly,
              maxTime: DateTime.now(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppTimePicker(
              label: 'time_of_occurence'.i18n(),
              onChanged: (value) => report.timeOfOccurrence = value,
              selectedTime: report.timeOfOccurrence,
              readOnly: widget.readOnly,
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      Scrollbar(
        controller: placeOfIncidentScrollController,
        thumbVisibility: true,
        child: AppTextField(
          keyboardType: TextInputType.multiline,
          controller: placeOfIncidentController,
          scrollController: placeOfIncidentScrollController,
          inputFormatters: [maxLineFormatter(3)],
          minLines: 3,
          maxLines: 3,
          maxLength: 100,
          label: 'place_of_incident'.i18n(),
          onChanged: (value) => report.placeOfIncident = value,
          readOnly: widget.readOnly,
        ),
      ),
    ]);
  }

  Widget _buildLine4(Report report) {
    return lineLayout(children: [
      Scrollbar(
        thumbVisibility: true,
        controller: accidentSummaryScrollController,
        child: AppTextField(
          keyboardType: TextInputType.multiline,
          controller: accidentSummaryController,
          scrollController: accidentSummaryScrollController,
          minLines: 3,
          maxLines: 3,
          maxLength: 100,
          label: 'accident_summary'.i18n(),
          onChanged: (value) => report.accidentSummary = value,
          readOnly: widget.readOnly,
        ),
      ),
    ]);
  }

}
