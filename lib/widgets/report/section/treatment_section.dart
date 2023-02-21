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
  final Report report;
  final bool readOnly;

  const TreatmentSection(
      {super.key, required this.report, this.readOnly = false});

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

  @override
  void initState() {
    super.initState();
    reactionDisposer = autorun((_) {
      syncControllerValue(
          o2AdministrationController, widget.report.o2Administration);
      syncControllerValue(
          bsMeasurement1Controller, widget.report.bsMeasurement1);
      syncControllerValue(punctureSite1Controller, widget.report.punctureSite1);
      syncControllerValue(
          bsMeasurement2Controller, widget.report.bsMeasurement2);
      syncControllerValue(punctureSite2Controller, widget.report.punctureSite2);
      syncControllerValue(otherController, widget.report.other);
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
          _buildLine1(widget.report),
          _buildLine2(widget.report),
          _buildLine3(widget.report),
          _buildLine4(widget.report),
          _buildLine5(widget.report),
          _buildLine6(widget.report),
          _buildLine7(widget.report),
          _buildLine8(widget.report),
          _buildLine9(widget.report),
          _buildLine10(widget.report),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
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
        AppDropdown<bool>(
          items: const [true, false],
          label: 'foreign_body_removal'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) {
            report.foreignBodyRemoval = value;
          },
          selectedItem: report.foreignBodyRemoval,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      AppDropdown<bool>(
        items: const [true, false],
        label: 'suction'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.suction = value;
        },
        selectedItem: report.suction,
        readOnly: widget.readOnly,
      ),
      AppDropdown<bool>(
        items: const [true, false],
        label: 'artificial_respiration'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.artificialRespiration = value;
        },
        selectedItem: report.artificialRespiration,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine3(Report report) {
    return lineLayout(children: [
      AppDropdown<bool>(
        items: const [true, false],
        label: 'chest_compressions'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.chestCompressions = value;
        },
        selectedItem: report.chestCompressions,
        readOnly: widget.readOnly,
      ),
      AppDropdown<bool>(
        items: const [true, false],
        label: 'ecg_monitor'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.ecgMonitor = value;
        },
        selectedItem: report.ecgMonitor,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine4(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTextField(
          label: 'o2_administration'.i18n(),
          controller: o2AdministrationController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) => report.o2Administration = int.parse(value),
          readOnly: widget.readOnly,
        ),
        AppTimePicker(
          label: 'o2_administration_time'.i18n(),
          onChanged: (value) => report.o2AdministrationTime = value,
          selectedTime: report.o2AdministrationTime,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine5(Report report) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd ==
                  AppConstants.spinalCordMovementLimitationCode)
              .toList(),
          label: 'spinal_cord_movement_limitation'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.spinalCordMovementLimitationType = value,
          selectedItem: report.spinalCordMovementLimitationType,
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
        AppDropdown<bool>(
          items: const [true, false],
          label: 'hemostatic_treatment'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) {
            report.hemostaticTreatment = value;
          },
          selectedItem: report.hemostaticTreatment,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine6(Report report) {
    return lineLayout(children: [
      AppDropdown<bool>(
        items: const [true, false],
        label: 'adductor_fixation'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) => report.adductorFixation = value,
        selectedItem: report.adductorFixation,
        readOnly: widget.readOnly,
      ),
      AppDropdown<bool>(
        items: const [true, false],
        label: 'coating'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) => report.coating = value,
        selectedItem: report.coating,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine7(Report report) {
    return lineLayout(children: [
      AppDropdown<bool>(
        items: const [true, false],
        label: 'burn_treatment'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) => report.burnTreatment = value,
        selectedItem: report.burnTreatment,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine8(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'bs_measurement_1'.i18n(),
                controller: bsMeasurement1Controller,
                keyboardType: TextInputType.number,
                onChanged: (item) => report.bsMeasurement1 = int.parse(item),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTimePicker(
                label: 'bs_measurement_time_1'.i18n(),
                onChanged: (value) => report.bsMeasurementTime1 = value,
                selectedTime: report.bsMeasurementTime1,
                readOnly: widget.readOnly,
              ),
            ),
          ],
        ),
        AppTextField(
          label: 'puncture_site_1'.i18n(),
          controller: punctureSite1Controller,
          onChanged: (value) => report.punctureSite1 = value,
          maxLength: 10,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine9(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'bs_measurement_2'.i18n(),
                controller: bsMeasurement2Controller,
                keyboardType: TextInputType.number,
                onChanged: (item) => report.bsMeasurement2 = int.parse(item),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTimePicker(
                label: 'bs_measurement_time_2'.i18n(),
                onChanged: (value) => report.bsMeasurementTime2 = value,
                selectedTime: report.bsMeasurementTime2,
                readOnly: widget.readOnly,
              ),
            ),
          ],
        ),
        AppTextField(
          label: 'puncture_site_2'.i18n(),
          controller: punctureSite2Controller,
          onChanged: (value) => report.punctureSite2 = value,
          maxLength: 10,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine10(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'other'.i18n(),
        controller: otherController,
        onChanged: (value) => report.other = value,
        maxLength: 60,
        maxLines: 1,
        readOnly: widget.readOnly,
      ),
    ]);
  }
}
