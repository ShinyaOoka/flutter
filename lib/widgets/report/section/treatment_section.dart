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
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class TreatmentSection extends StatefulWidget {
  final bool readOnly;

  const TreatmentSection({super.key, this.readOnly = false});

  @override
  State<TreatmentSection> createState() => _TreatmentSectionState();
}

class _TreatmentSectionState extends State<TreatmentSection>
    with ReportSectionMixin {
  final o2AdministrationController = TextEditingController();
  final bsMeasurement1Controller = TextEditingController();
  final punctureSite1Controller = TextEditingController();
  final bsMeasurement2Controller = TextEditingController();
  final punctureSite2Controller = TextEditingController();
  final otherController = TextEditingController();
  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(o2AdministrationController,
          reportStore.selectingReport!.o2Administration);
      syncControllerValue(bsMeasurement1Controller,
          reportStore.selectingReport!.bsMeasurement1);
      syncControllerValue(
          punctureSite1Controller, reportStore.selectingReport!.punctureSite1);
      syncControllerValue(bsMeasurement2Controller,
          reportStore.selectingReport!.bsMeasurement2);
      syncControllerValue(
          punctureSite2Controller, reportStore.selectingReport!.punctureSite2);
      syncControllerValue(otherController, reportStore.selectingReport!.other);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    o2AdministrationController.dispose();
    bsMeasurement1Controller.dispose();
    punctureSite1Controller.dispose();
    bsMeasurement2Controller.dispose();
    punctureSite2Controller.dispose();
    otherController.dispose();
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
    return lineLayout(dense: true, children: [
      AppCheckbox(
        label: 'foreign_body_removal'.i18n(),
        value: report.foreignBodyRemoval,
        onChanged: (value) => report.foreignBodyRemoval = value,
        readOnly: widget.readOnly,
      ),
      AppCheckbox(
        label: 'suction'.i18n(),
        value: report.suction,
        onChanged: (value) => report.suction = value,
        readOnly: widget.readOnly,
      ),
      AppCheckbox(
        label: 'artificial_respiration'.i18n(),
        value: report.artificialRespiration,
        onChanged: (value) => report.artificialRespiration = value,
        readOnly: widget.readOnly,
      ),
      AppCheckbox(
        label: 'chest_compressions'.i18n(),
        value: report.chestCompressions,
        onChanged: (value) => report.chestCompressions = value,
        readOnly: widget.readOnly,
      ),
      AppCheckbox(
        label: 'ecg_monitor'.i18n(),
        value: report.ecgMonitor,
        onChanged: (value) => report.ecgMonitor = value,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      AppCheckbox(
        label: 'burn_treatment'.i18n(),
        value: report.burnTreatment,
        onChanged: (value) => report.burnTreatment = value,
        readOnly: widget.readOnly,
      ),
      AppCheckbox(
        label: 'hemostatic_treatment'.i18n(),
        value: report.hemostaticTreatment,
        onChanged: (value) => report.hemostaticTreatment = value,
        readOnly: widget.readOnly,
      ),
      AppCheckbox(
        label: 'adductor_fixation'.i18n(),
        value: report.adductorFixation,
        onChanged: (value) => report.adductorFixation = value,
        readOnly: widget.readOnly,
      ),
      AppCheckbox(
        label: 'coating'.i18n(),
        value: report.coating,
        onChanged: (value) => report.coating = value,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine3(Report report) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd == AppConstants.securingAirwayCode)
            .toList(),
        label: 'securing_airway'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.securingAirwayType = value,
        selectedItem: report.securingAirwayType,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
      ),
      AppDropdown<Classification>(
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd ==
                AppConstants.limitationOfSpinalMotionCode)
            .toList(),
        label: 'limitation_of_spinal_motion'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.limitationOfSpinalMotionType = value,
        selectedItem: report.limitationOfSpinalMotionType,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine4(Report report) {
    return lineLayout(children: [
      Focus(
        child: AppTextField(
          label: 'o2_administration'.i18n(),
          controller: o2AdministrationController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]{0,2}(\.[0-9]?)?')),
            FilteringTextInputFormatter.singleLineFormatter,
          ],
          readOnly: widget.readOnly,
          counterText: 'L',
          counterColor: Theme.of(context).primaryColor,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          report.o2Administration =
              double.tryParse(o2AdministrationController.text);
        },
      ),
      AppTimePicker(
        label: 'o2_administration_time'.i18n(),
        onChanged: (value) => report.o2AdministrationTime = value,
        selectedTime: report.o2AdministrationTime,
        readOnly: widget.readOnly,
        defaultTime: report.contactTime,
      ),
    ]);
  }

  Widget _buildLine5(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'bs_measurement_1'.i18n(),
                controller: bsMeasurement1Controller,
                keyboardType: TextInputType.number,
                onChanged: (item) => report.bsMeasurement1 = int.tryParse(item),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
                maxLength: 3,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTimePicker(
                label: 'bs_measurement_time_1'.i18n(),
                onChanged: (value) => report.bsMeasurementTime1 = value,
                selectedTime: report.bsMeasurementTime1,
                readOnly: widget.readOnly,
                defaultTime: report.contactTime,
              ),
            ),
          ],
        ),
        AppTextField(
          label: 'puncture_site_1'.i18n(),
          controller: punctureSite1Controller,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => report.punctureSite1 = value,
          maxLength: 10,
          maxLines: 1,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.multiline,
        ),
      ]);
    });
  }

  Widget _buildLine6(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'bs_measurement_2'.i18n(),
                controller: bsMeasurement2Controller,
                keyboardType: TextInputType.number,
                onChanged: (item) => report.bsMeasurement2 = int.tryParse(item),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
                maxLength: 3,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTimePicker(
                label: 'bs_measurement_time_2'.i18n(),
                onChanged: (value) => report.bsMeasurementTime2 = value,
                selectedTime: report.bsMeasurementTime2,
                readOnly: widget.readOnly,
                defaultTime: report.contactTime,
              ),
            ),
          ],
        ),
        AppTextField(
          label: 'puncture_site_2'.i18n(),
          controller: punctureSite2Controller,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => report.punctureSite2 = value,
          maxLength: 10,
          readOnly: widget.readOnly,
          maxLines: 1,
          keyboardType: TextInputType.multiline,
        ),
      ]);
    });
  }

  Widget _buildLine7(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'other'.i18n(),
        controller: otherController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.other = value,
        maxLength: 20,
        maxLines: 1,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
    ]);
  }
}
