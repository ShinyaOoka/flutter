import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
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
  final verbalGuidanceController = TextEditingController();
  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(placeOfIncidentController,
          reportStore.selectingReport!.placeOfIncident);
      syncControllerValue(placeOfDispatchController,
          reportStore.selectingReport!.placeOfDispatch);
      syncControllerValue(accidentSummaryController,
          reportStore.selectingReport!.accidentSummary);
      syncControllerValue(verbalGuidanceController,
          reportStore.selectingReport!.verbalGuidance);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    placeOfIncidentController.dispose();
    placeOfDispatchController.dispose();
    accidentSummaryController.dispose();
    verbalGuidanceController.dispose();
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
          _buildLine3(reportStore.selectingReport!),
          _buildLine4(reportStore.selectingReport!),
          _buildLine5(reportStore.selectingReport!),
          _buildLine6(reportStore.selectingReport!),
          _buildLine7(reportStore.selectingReport!),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          showSearchBox: true,
          items: classificationStore.classifications.values
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
    });
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      AppTextField(
        keyboardType: TextInputType.multiline,
        controller: placeOfIncidentController,
        inputFormatters: [maxLineFormatter(3)],
        minLines: 3,
        maxLines: 3,
        maxLength: 100,
        label: 'place_of_incident'.i18n(),
        onChanged: (value) => report.placeOfIncident = value,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine3(Report report) {
    return lineLayout(children: [
      AppTextField(
        keyboardType: TextInputType.multiline,
        controller: placeOfDispatchController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        maxLength: 25,
        label: 'place_of_dispatch'.i18n(),
        onChanged: (value) => report.placeOfDispatch = value,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine4(Report report) {
    return lineLayout(children: [
      AppTextField(
        keyboardType: TextInputType.multiline,
        controller: accidentSummaryController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        minLines: 3,
        maxLines: 3,
        maxLength: 100,
        label: 'accident_summary'.i18n(),
        onChanged: (value) => report.accidentSummary = value,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine5(Report report) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where(
                  (element) => element.classificationCd == AppConstants.adlCode)
              .toList(),
          label: 'adl'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.adlType = value,
          selectedItem: report.adlType,
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.trafficAccidentCode)
              .toList(),
          label: 'traffic_accident_classification'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) {
            report.trafficAccidentType = value;
          },
          selectedItem: report.trafficAccidentType,
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine6(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppDropdown<bool>(
          items: const [true, false],
          label: 'witnesses'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) => report.witnesses = value,
          selectedItem: report.witnesses,
          readOnly: widget.readOnly,
        ),
        AppTimePicker(
          label: 'bystander_cpr'.i18n(),
          onChanged: (value) => report.bystanderCpr = value,
          selectedTime: report.bystanderCpr,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine7(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'verbal_guidance'.i18n(),
        controller: verbalGuidanceController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.verbalGuidance = value,
        maxLength: 60,
        maxLines: 1,
        readOnly: widget.readOnly,
      ),
    ]);
  }
}
