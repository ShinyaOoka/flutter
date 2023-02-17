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

class VitalSignSection extends StatefulWidget {
  final Report report;
  final int index;
  final TextEditingController respirationController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController bloodPressureHighController =
      TextEditingController();
  final TextEditingController bloodPressureLowController =
      TextEditingController();
  final TextEditingController spO2PercentController = TextEditingController();

  VitalSignSection({super.key, required this.report, required this.index});

  @override
  State<VitalSignSection> createState() => _VitalSignSectionState();
}

class _VitalSignSectionState extends State<VitalSignSection>
    with ReportSectionMixin {
  @override
  void initState() {
    super.initState();
    widget.report.jcsTypes = _ensureLength(widget.report.jcsTypes);
    widget.report.observationTime =
        _ensureLengthObservable(widget.report.observationTime);
    widget.report.gcsETypes = _ensureLength(widget.report.gcsETypes);
    widget.report.gcsVTypes = _ensureLength(widget.report.gcsVTypes);
    widget.report.gcsMTypes = _ensureLength(widget.report.gcsMTypes);
    widget.report.respiration =
        _ensureLengthObservable(widget.report.respiration);
    widget.report.pulse = _ensureLengthObservable(widget.report.pulse);
    widget.report.bloodPressureHigh =
        _ensureLengthObservable(widget.report.bloodPressureHigh);
    widget.report.bloodPressureLow =
        _ensureLengthObservable(widget.report.bloodPressureLow);
    widget.report.spO2Liter = _ensureLengthObservable(widget.report.spO2Liter);
    widget.report.spO2Percent =
        _ensureLengthObservable(widget.report.spO2Percent);
    widget.report.pupilLeft = _ensureLengthObservable(widget.report.pupilLeft);
    widget.report.pupilRight =
        _ensureLengthObservable(widget.report.pupilRight);
    widget.report.lightReflexLeft =
        _ensureLengthObservable(widget.report.lightReflexLeft);
    widget.report.lightReflexRight =
        _ensureLengthObservable(widget.report.lightReflexRight);
    widget.report.bodyTemperature =
        _ensureLengthObservable(widget.report.bodyTemperature);
    widget.report.hemorrhage =
        _ensureLengthObservable(widget.report.hemorrhage);
    widget.report.vomiting = _ensureLengthObservable(widget.report.vomiting);
    widget.report.extremities =
        _ensureLengthObservable(widget.report.extremities);
    widget.report.observationTimeDescriptionTypes =
        _ensureLength(widget.report.observationTimeDescriptionTypes);
    widget.report.incontinenceTypes =
        _ensureLength(widget.report.incontinenceTypes);
    widget.report.facialFeatureTypes =
        _ensureLength(widget.report.facialFeatureTypes);

    widget.respirationController.addListener(() {
      print("changed");
      print(widget.respirationController.text);

      widget.report.respiration?[widget.index] =
          int.tryParse(widget.respirationController.text);
    });

    autorun((_) {
      final newRespiration =
          widget.report.respiration?[widget.index]?.toString() ?? '';
      if (newRespiration != widget.respirationController.text) {
        widget.respirationController.text = newRespiration;
      }

      final newBloodPressureHigh =
          widget.report.bloodPressureHigh?[widget.index]?.toString() ?? '';
      if (newBloodPressureHigh != widget.bloodPressureHighController.text) {
        widget.bloodPressureHighController.text = newBloodPressureHigh;
      }

      final newBloodPressureLow =
          widget.report.bloodPressureLow?[widget.index]?.toString() ?? '';
      if (newBloodPressureLow != widget.bloodPressureLowController.text) {
        widget.bloodPressureLowController.text = newBloodPressureLow;
      }

      final newSpO2Percent =
          widget.report.spO2Percent?[widget.index]?.toString() ?? '';
      if (newSpO2Percent != widget.spO2PercentController.text) {
        widget.spO2PercentController.text = newSpO2Percent;
      }

      final newPulse = widget.report.pulse?[widget.index]?.toString() ?? '';
      if (newPulse != widget.pulseController.text) {
        widget.pulseController.text = newPulse;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(widget.report, context),
        _buildLine2(widget.report, context),
        _buildLine3(widget.report, context),
        _buildLine4(widget.report, context),
        _buildLine5(widget.report, context),
        _buildLine6(widget.report, context),
        _buildLine7(widget.report, context),
        _buildLine8(widget.report, context),
      ],
    );
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppTimePicker(
          label: 'observation_time'.i18n(),
          onChanged: (value) => report.observationTime?[widget.index] = value,
          selectedTime: report.observationTime?[widget.index],
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where(
                  (element) => element.classificationCd == AppConstants.jcsCode)
              .toList(),
          label: 'jcs'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.jcsTypes = report.jcsTypes
              .mapIndexed((i, e) => i == widget.index ? value : e)
              .toList(),
          selectedItem: report.jcsTypes[widget.index],
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
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
              .mapIndexed((i, e) => i == widget.index ? value : e)
              .toList(),
          selectedItem: report.gcsETypes[widget.index],
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.gcsVCode)
              .toList(),
          label: 'gcs_v'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.gcsVTypes = report.gcsVTypes
              .mapIndexed((i, e) => i == widget.index ? value : e)
              .toList(),
          selectedItem: report.gcsVTypes[widget.index],
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.gcsMCode)
              .toList(),
          label: 'gcs_m'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.gcsMTypes = report.gcsMTypes
              .mapIndexed((i, e) => i == widget.index ? value : e)
              .toList(),
          selectedItem: report.gcsMTypes[widget.index],
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
        ),
      ]);
    });
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'respiration'.i18n(),
        controller: widget.respirationController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        counterText: 'times_per_minute'.i18n(),
        counterColor: Theme.of(context).primaryColor,
        maxLength: 3,
      ),
      AppTextField(
        label: 'pulse'.i18n(),
        controller: widget.pulseController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        counterText: 'times_per_minute'.i18n(),
        counterColor: Theme.of(context).primaryColor,
        maxLength: 3,
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
                controller: widget.bloodPressureHighController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'blood_pressure_low'.i18n(),
                controller: widget.bloodPressureLowController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: AppTextField(
                label: 'sp_o2_percent'.i18n(),
                controller: widget.spO2PercentController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                counterText: '%'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'sp_o2_liter'.i18n(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) =>
                    report.spO2Liter?[widget.index] = int.parse(value),
                counterText: 'L'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
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
                    report.pupilRight?[widget.index] = int.parse(value),
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
                    report.pupilLeft?[widget.index] = int.parse(value),
                counterText: 'mm'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
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
                  onChanged: (value) =>
                      report.lightReflexRight?[widget.index] = value,
                  selectedItem: report.lightReflexRight?[widget.index],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdown<bool>(
                  items: const [true, false],
                  label: 'light_reflex_left'.i18n(),
                  itemAsString: ((item) => formatBool(item) ?? ''),
                  onChanged: (value) =>
                      report.lightReflexLeft?[widget.index] = value,
                  selectedItem: report.lightReflexLeft?[widget.index],
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
          ],
          onChanged: (value) =>
              report.bodyTemperature?[widget.index] = double.parse(value),
          counterText: 'celsius'.i18n(),
          counterColor: Theme.of(context).primaryColor,
          maxLength: 3,
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
              .mapIndexed((i, e) => i == widget.index ? value : e)
              .toList(),
          selectedItem: report.facialFeatureTypes[widget.index],
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
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
          onChanged: (value) => report.hemorrhage?[widget.index] = value,
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
              .mapIndexed((i, e) => i == widget.index ? value : e)
              .toList(),
          selectedItem: report.incontinenceTypes[widget.index],
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
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
          onChanged: (value) => report.vomiting?[widget.index] = value,
          selectedItem: report.vomiting?[widget.index],
        ),
        AppTextField(
          label: 'extremities'.i18n(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) => report.extremities?[widget.index] = value,
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
                    .mapIndexed((i, e) => i == widget.index ? value : e)
                    .toList(),
            selectedItem: report.observationTimeDescriptionTypes[widget.index],
            filterFn: (c, filter) =>
                (c.value != null && c.value!.contains(filter)) ||
                (c.classificationSubCd != null &&
                    c.classificationSubCd!.contains(filter)),
          ),
          context: context,
        ),
        Container(),
      ]);
    });
  }

  ObservableList<T?> _ensureLengthObservable<T>(ObservableList<T?>? list) {
    if (list != null && list.length > widget.index) return list;
    list ??= List<T?>.filled(widget.index + 1, null).asObservable();
    if (list.length <= widget.index) {
      list.addAll(List.filled(widget.index + 1 - list.length, null));
    }
    return list;
  }

  List<T?> _ensureLength<T>(List<T?>? list) {
    if (list != null && list.length > widget.index) return list;
    list ??= List<T?>.filled(widget.index + 1, null);
    if (list.length <= widget.index) {
      list.addAll(List.filled(widget.index + 1 - list.length, null));
    }
    return list;
  }
}
