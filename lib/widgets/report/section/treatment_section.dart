import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

class TreatmentSection extends StatelessWidget with ReportSectionMixin {
  final Report report;

  TreatmentSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(report),
        _buildLine2(report),
        _buildLine3(report),
        _buildLine4(report),
        _buildLine5(report),
        _buildLine6(report),
        _buildLine7(report),
        _buildLine8(report),
        _buildLine9(report),
        _buildLine10(report),
      ],
    );
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
        ),
        AppDropdown<bool>(
          items: const [true, false],
          label: 'foreign_body_removal'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) {
            report.foreignBodyRemoval = value;
          },
          selectedItem: report.foreignBodyRemoval,
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
      ),
      AppDropdown<bool>(
        items: const [true, false],
        label: 'artificial_respiration'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.artificialRespiration = value;
        },
        selectedItem: report.artificialRespiration,
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
      ),
      AppDropdown<bool>(
        items: const [true, false],
        label: 'ecg_monitor'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.ecgMonitor = value;
        },
        selectedItem: report.ecgMonitor,
      ),
    ]);
  }

  Widget _buildLine4(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTextField(
          label: 'o2_administration'.i18n(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            report.o2Administration = int.parse(value);
          },
        ),
        AppTimePicker(
          label: 'o2_administration_time'.i18n(),
          onChanged: (value) => report.o2AdministrationTime = value,
          selectedTime: report.o2AdministrationTime,
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
        ),
        AppDropdown<bool>(
          items: const [true, false],
          label: 'hemostatic_treatment'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) {
            report.hemostaticTreatment = value;
          },
          selectedItem: report.hemostaticTreatment,
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
        onChanged: (value) {
          report.adductorFixation = value;
        },
        selectedItem: report.adductorFixation,
      ),
      AppDropdown<bool>(
        items: const [true, false],
        label: 'coating'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.coating = value;
        },
        selectedItem: report.coating,
      ),
    ]);
  }

  Widget _buildLine7(Report report) {
    return lineLayout(children: [
      AppDropdown<bool>(
        items: const [true, false],
        label: 'burn_treatment'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.burnTreatment = value;
        },
        selectedItem: report.burnTreatment,
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
                keyboardType: TextInputType.number,
                onChanged: (item) => report.bsMeasurement1 = int.parse(item),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTimePicker(
                label: 'bs_measurement_time_1'.i18n(),
                onChanged: (value) => report.bsMeasurementTime1 = value,
                selectedTime: report.bsMeasurementTime1,
              ),
            ),
          ],
        ),
        AppTextField(
          label: 'puncture_site_1'.i18n(),
          onChanged: (value) => report.punctureSite1 = value,
          maxLength: 10,
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
                keyboardType: TextInputType.number,
                onChanged: (item) => report.bsMeasurement2 = int.parse(item),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTimePicker(
                label: 'bs_measurement_time_2'.i18n(),
                onChanged: (value) => report.bsMeasurementTime2 = value,
                selectedTime: report.bsMeasurementTime2,
              ),
            ),
          ],
        ),
        AppTextField(
          label: 'puncture_site_2'.i18n(),
          onChanged: (value) => report.punctureSite2 = value,
          maxLength: 10,
        ),
      ]);
    });
  }

  Widget _buildLine10(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'other'.i18n(),
        onChanged: (value) => report.other = value,
        maxLength: 60,
      ),
    ]);
  }
}
