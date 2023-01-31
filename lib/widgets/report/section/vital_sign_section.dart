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
import 'package:collection/collection.dart';

class VitalSignSection extends StatelessWidget with ReportSectionMixin {
  final Report report;
  final int index;

  VitalSignSection({super.key, required this.report, required this.index});

  @override
  Widget build(BuildContext context) {
    report.jcsTypes = _ensureLength(report.jcsTypes);
    report.observationTime = _ensureLengthObservable(report.observationTime);
    report.gcsETypes = _ensureLength(report.gcsETypes);
    report.gcsVTypes = _ensureLength(report.gcsVTypes);
    report.gcsMTypes = _ensureLength(report.gcsMTypes);
    report.respiration = _ensureLengthObservable(report.respiration);
    report.pulse = _ensureLengthObservable(report.pulse);
    report.bloodPressureHigh =
        _ensureLengthObservable(report.bloodPressureHigh);
    report.bloodPressureLow = _ensureLengthObservable(report.bloodPressureLow);
    report.spO2Liter = _ensureLengthObservable(report.spO2Liter);
    report.spO2Percent = _ensureLengthObservable(report.spO2Percent);
    report.pupilLeft = _ensureLengthObservable(report.pupilLeft);
    report.pupilRight = _ensureLengthObservable(report.pupilRight);
    report.lightReflexLeft = _ensureLengthObservable(report.lightReflexLeft);
    report.lightReflexRight = _ensureLengthObservable(report.lightReflexRight);
    report.bodyTemperature = _ensureLengthObservable(report.bodyTemperature);
    report.hemorrhage = _ensureLengthObservable(report.hemorrhage);
    report.vomiting = _ensureLengthObservable(report.vomiting);
    report.extremities = _ensureLengthObservable(report.extremities);
    report.observationTimeDescriptionTypes =
        _ensureLength(report.observationTimeDescriptionTypes);
    report.incontinenceTypes = _ensureLength(report.incontinenceTypes);
    report.facialFeatureTypes = _ensureLength(report.facialFeatureTypes);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(report, context),
        _buildLine2(report, context),
        _buildLine3(report, context),
        _buildLine4(report, context),
        _buildLine5(report, context),
        _buildLine6(report, context),
        _buildLine7(report, context),
        _buildLine8(report, context),
      ],
    );
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppTimePicker(
          label: 'observation_time'.i18n(),
          onChanged: (value) => report.observationTime?[index] = value,
          selectedTime: report.observationTime?[index],
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where(
                  (element) => element.classificationCd == AppConstants.jcsCode)
              .toList(),
          label: 'jcs'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.jcsTypes = report.jcsTypes
              .mapIndexed((i, e) => i == index ? value : e)
              .toList(),
          selectedItem: report.jcsTypes[index],
        )
      ]);
    });
  }

  Widget _buildLine2(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.gcsECode)
              .toList(),
          label: 'gcs_e'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.gcsETypes = report.gcsETypes
              .mapIndexed((i, e) => i == index ? value : e)
              .toList(),
          selectedItem: report.gcsETypes[index],
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.gcsVCode)
              .toList(),
          label: 'gcs_v'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.gcsVTypes = report.gcsVTypes
              .mapIndexed((i, e) => i == index ? value : e)
              .toList(),
          selectedItem: report.gcsVTypes[index],
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.gcsMCode)
              .toList(),
          label: 'gcs_m'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.gcsMTypes = report.gcsMTypes
              .mapIndexed((i, e) => i == index ? value : e)
              .toList(),
          selectedItem: report.gcsMTypes[index],
        ),
      ]);
    });
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'respiration'.i18n(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => report.respiration?[index] = int.parse(value),
        counterText: 'times_per_minute'.i18n(),
        counterColor: Theme.of(context).primaryColor,
      ),
      AppTextField(
        label: 'pulse'.i18n(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => report.pulse?[index] = int.parse(value),
        counterText: 'times_per_minute'.i18n(),
        counterColor: Theme.of(context).primaryColor,
      ),
    ]);
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return lineLayout(children: [
      Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: AppTextField(
                label: 'blood_pressure_high'.i18n(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) =>
                    report.bloodPressureHigh?[index] = int.parse(value),
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'blood_pressure_low'.i18n(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) =>
                    report.bloodPressureLow?[index] = int.parse(value),
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: AppTextField(
                label: 'sp_o2_percent'.i18n(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) =>
                    report.spO2Percent?[index] = int.parse(value),
                counterText: '%'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'sp_o2_liter'.i18n(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) =>
                    report.spO2Liter?[index] = int.parse(value),
                counterText: 'L'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              )),
            ],
          )
        ],
      ),
      Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: AppTextField(
                label: 'pupil_right'.i18n(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) =>
                    report.pupilRight?[index] = int.parse(value),
                counterText: 'mm'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'pupil_left'.i18n(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) =>
                    report.pupilLeft?[index] = int.parse(value),
                counterText: 'mm'.i18n(),
                counterColor: Theme.of(context).primaryColor,
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AppDropdown<bool>(
                  items: const [true, false],
                  label: 'light_reflex_right'.i18n(),
                  itemAsString: ((item) => formatBool(item) ?? ''),
                  onChanged: (value) => report.lightReflexRight?[index] = value,
                  selectedItem: report.lightReflexRight?[index],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdown<bool>(
                  items: const [true, false],
                  label: 'light_reflex_left'.i18n(),
                  itemAsString: ((item) => formatBool(item) ?? ''),
                  onChanged: (value) => report.lightReflexLeft?[index] = value,
                  selectedItem: report.lightReflexLeft?[index],
                ),
              ),
            ],
          )
        ],
      ),
    ]);
  }

  Widget _buildLine5(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppTextField(
          label: 'body_temperature'.i18n(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) =>
              report.bodyTemperature?[index] = int.parse(value),
          counterText: 'celsius'.i18n(),
          counterColor: Theme.of(context).primaryColor,
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.facialFeaturesCode)
              .toList(),
          label: 'facial_features'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.facialFeatureTypes = report
              .facialFeatureTypes
              .mapIndexed((i, e) => i == index ? value : e)
              .toList(),
          selectedItem: report.facialFeatureTypes[index],
        )
      ]);
    });
  }

  Widget _buildLine6(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppTextField(
          label: 'hemorrhage'.i18n(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) => report.hemorrhage?[index] = value,
          maxLength: 10,
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.incontinenceCode)
              .toList(),
          label: 'incontinence'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.incontinenceTypes = report
              .incontinenceTypes
              .mapIndexed((i, e) => i == index ? value : e)
              .toList(),
          selectedItem: report.incontinenceTypes[index],
        ),
      ]);
    });
  }

  Widget _buildLine7(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppDropdown<bool>(
          items: const [true, false],
          label: 'vomitting'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) => report.vomiting?[index] = value,
          selectedItem: report.vomiting?[index],
        ),
        AppTextField(
          label: 'extremities'.i18n(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) => report.extremities?[index] = value,
          maxLength: 10,
        ),
      ]);
    });
  }

  Widget _buildLine8(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        optional(
          child: AppDropdown<Classification>(
            items: classificationStore.classifications.values
                .where((element) =>
                    element.classificationCd ==
                    AppConstants.descriptionOfObservationTimeCode)
                .toList(),
            label: 'description_of_observation_time'.i18n(),
            itemAsString: ((item) => item.value ?? ''),
            onChanged: (value) => report.observationTimeDescriptionTypes =
                report.observationTimeDescriptionTypes
                    .mapIndexed((i, e) => i == index ? value : e)
                    .toList(),
            selectedItem: report.observationTimeDescriptionTypes[index],
          ),
          context: context,
        ),
        Container(),
      ]);
    });
  }

  ObservableList<T?> _ensureLengthObservable<T>(ObservableList<T?>? list) {
    if (list != null && list.length > index) return list;
    list ??= List<T?>.filled(index + 1, null).asObservable();
    if (list.length <= index) {
      list.addAll(List.filled(index + 1 - list.length, null));
    }
    return list;
  }

  List<T?> _ensureLength<T>(List<T?>? list) {
    if (list != null && list.length > index) return list;
    list ??= List<T?>.filled(index + 1, null);
    if (list.length <= index) {
      list.addAll(List.filled(index + 1 - list.length, null));
    }
    return list;
  }
}
