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
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:collection/collection.dart';

class VitalSignSection extends StatefulWidget {
  final int index;
  final readOnly;

  const VitalSignSection(
      {super.key, required this.index, this.readOnly = false});

  @override
  State<VitalSignSection> createState() => _VitalSignSectionState();
}

class _VitalSignSectionState extends State<VitalSignSection>
    with ReportSectionMixin {
  final respirationController = TextEditingController();
  final pulseController = TextEditingController();
  final bloodPressureHighController = TextEditingController();
  final bloodPressureLowController = TextEditingController();
  final spO2PercentController = TextEditingController();
  final spO2LiterController = TextEditingController();
  final pupilRightController = TextEditingController();
  final pupilLeftController = TextEditingController();
  final bodyTemperatureController = TextEditingController();
  final hemorrhageController = TextEditingController();
  final extremitiesController = TextEditingController();
  final eachEcgController = TextEditingController();
  final eachOxygenInhalationController = TextEditingController();
  final otherProcess1Controller = TextEditingController();
  final otherProcess2Controller = TextEditingController();
  final otherProcess3Controller = TextEditingController();
  final otherProcess4Controller = TextEditingController();
  final otherProcess5Controller = TextEditingController();
  final otherProcess6Controller = TextEditingController();
  final otherProcess7Controller = TextEditingController();
  final otherProcess8Controller = TextEditingController();
  final otherProcess9Controller = TextEditingController();
  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reportStore.selectingReport!.jcsTypes =
        _ensureLength(reportStore.selectingReport!.jcsTypes);
    reportStore.selectingReport!.observationTime =
        _ensureLengthObservable(reportStore.selectingReport!.observationTime);
    reportStore.selectingReport!.gcsETypes =
        _ensureLength(reportStore.selectingReport!.gcsETypes);
    reportStore.selectingReport!.gcsVTypes =
        _ensureLength(reportStore.selectingReport!.gcsVTypes);
    reportStore.selectingReport!.gcsMTypes =
        _ensureLength(reportStore.selectingReport!.gcsMTypes);
    reportStore.selectingReport!.respiration =
        _ensureLengthObservable(reportStore.selectingReport!.respiration);
    reportStore.selectingReport!.pulse =
        _ensureLengthObservable(reportStore.selectingReport!.pulse);
    reportStore.selectingReport!.bloodPressureHigh =
        _ensureLengthObservable(reportStore.selectingReport!.bloodPressureHigh);
    reportStore.selectingReport!.bloodPressureLow =
        _ensureLengthObservable(reportStore.selectingReport!.bloodPressureLow);
    reportStore.selectingReport!.spO2Liter =
        _ensureLengthObservable(reportStore.selectingReport!.spO2Liter);
    reportStore.selectingReport!.spO2Percent =
        _ensureLengthObservable(reportStore.selectingReport!.spO2Percent);
    reportStore.selectingReport!.pupilLeft =
        _ensureLengthObservable(reportStore.selectingReport!.pupilLeft);
    reportStore.selectingReport!.pupilRight =
        _ensureLengthObservable(reportStore.selectingReport!.pupilRight);
    reportStore.selectingReport!.lightReflexLeft =
        _ensureLengthObservable(reportStore.selectingReport!.lightReflexLeft);
    reportStore.selectingReport!.lightReflexRight =
        _ensureLengthObservable(reportStore.selectingReport!.lightReflexRight);
    reportStore.selectingReport!.bodyTemperature =
        _ensureLengthObservable(reportStore.selectingReport!.bodyTemperature);
    reportStore.selectingReport!.hemorrhage =
        _ensureLengthObservable(reportStore.selectingReport!.hemorrhage);
    reportStore.selectingReport!.vomiting =
        _ensureLengthObservable(reportStore.selectingReport!.vomiting);
    reportStore.selectingReport!.extremities =
        _ensureLengthObservable(reportStore.selectingReport!.extremities);
    reportStore.selectingReport!.eachEcg =
        _ensureLengthObservable(reportStore.selectingReport!.eachEcg);
    reportStore.selectingReport!.eachHemostasis =
        _ensureLengthObservable(reportStore.selectingReport!.eachHemostasis);
    reportStore.selectingReport!.eachOxygenInhalation = _ensureLengthObservable(
        reportStore.selectingReport!.eachOxygenInhalation);
    reportStore.selectingReport!.eachSuction =
        _ensureLengthObservable(reportStore.selectingReport!.eachSuction);
    reportStore.selectingReport!.otherProcess1 =
        _ensureLengthObservable(reportStore.selectingReport!.otherProcess1);
    reportStore.selectingReport!.otherProcess2 =
        _ensureLengthObservable(reportStore.selectingReport!.otherProcess2);
    reportStore.selectingReport!.otherProcess3 =
        _ensureLengthObservable(reportStore.selectingReport!.otherProcess3);
    reportStore.selectingReport!.otherProcess4 =
        _ensureLengthObservable(reportStore.selectingReport!.otherProcess4);
    reportStore.selectingReport!.otherProcess5 =
        _ensureLengthObservable(reportStore.selectingReport!.otherProcess5);
    reportStore.selectingReport!.otherProcess6 =
        _ensureLengthObservable(reportStore.selectingReport!.otherProcess6);
    reportStore.selectingReport!.otherProcess7 =
        _ensureLengthObservable(reportStore.selectingReport!.otherProcess7);
    reportStore.selectingReport!.observationTimeDescriptionTypes =
        _ensureLength(
            reportStore.selectingReport!.observationTimeDescriptionTypes);
    reportStore.selectingReport!.incontinenceTypes =
        _ensureLength(reportStore.selectingReport!.incontinenceTypes);
    reportStore.selectingReport!.facialFeatureTypes =
        _ensureLength(reportStore.selectingReport!.facialFeatureTypes);

    reactionDisposer = autorun((_) {
      syncControllerValue(respirationController,
          reportStore.selectingReport!.respiration?[widget.index]);
      syncControllerValue(bloodPressureHighController,
          reportStore.selectingReport!.bloodPressureHigh?[widget.index]);
      syncControllerValue(bloodPressureLowController,
          reportStore.selectingReport!.bloodPressureLow?[widget.index]);
      syncControllerValue(spO2PercentController,
          reportStore.selectingReport!.spO2Percent?[widget.index]);
      syncControllerValue(
          pulseController, reportStore.selectingReport!.pulse?[widget.index]);
      syncControllerValue(spO2LiterController,
          reportStore.selectingReport!.spO2Liter?[widget.index]);
      syncControllerValue(pupilRightController,
          reportStore.selectingReport!.pupilRight?[widget.index]);
      syncControllerValue(pupilLeftController,
          reportStore.selectingReport!.pupilLeft?[widget.index]);
      syncControllerValue(bodyTemperatureController,
          reportStore.selectingReport!.bodyTemperature?[widget.index]);
      syncControllerValue(hemorrhageController,
          reportStore.selectingReport!.hemorrhage?[widget.index]);
      syncControllerValue(extremitiesController,
          reportStore.selectingReport!.extremities?[widget.index]);
      syncControllerValue(eachOxygenInhalationController,
          reportStore.selectingReport!.eachOxygenInhalation?[widget.index]);
      syncControllerValue(eachEcgController,
          reportStore.selectingReport!.eachEcg?[widget.index]);
      syncControllerValue(otherProcess1Controller,
          reportStore.selectingReport!.otherProcess1?[widget.index]);
      syncControllerValue(otherProcess2Controller,
          reportStore.selectingReport!.otherProcess2?[widget.index]);
      syncControllerValue(otherProcess3Controller,
          reportStore.selectingReport!.otherProcess3?[widget.index]);
      syncControllerValue(otherProcess4Controller,
          reportStore.selectingReport!.otherProcess4?[widget.index]);
      syncControllerValue(otherProcess5Controller,
          reportStore.selectingReport!.otherProcess5?[widget.index]);
      syncControllerValue(otherProcess6Controller,
          reportStore.selectingReport!.otherProcess6?[widget.index]);
      syncControllerValue(otherProcess7Controller,
          reportStore.selectingReport!.otherProcess7?[widget.index]);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    respirationController.dispose();
    pulseController.dispose();
    bloodPressureHighController.dispose();
    bloodPressureLowController.dispose();
    spO2PercentController.dispose();
    spO2LiterController.dispose();
    pupilRightController.dispose();
    pupilLeftController.dispose();
    bodyTemperatureController.dispose();
    hemorrhageController.dispose();
    extremitiesController.dispose();
    eachEcgController.dispose();
    eachOxygenInhalationController.dispose();
    otherProcess1Controller.dispose();
    otherProcess2Controller.dispose();
    otherProcess3Controller.dispose();
    otherProcess4Controller.dispose();
    otherProcess5Controller.dispose();
    otherProcess6Controller.dispose();
    otherProcess7Controller.dispose();
    otherProcess8Controller.dispose();
    otherProcess9Controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLine1(reportStore.selectingReport!, context),
          _buildLine2(reportStore.selectingReport!, context),
          _buildLine3(reportStore.selectingReport!, context),
          _buildLine4(reportStore.selectingReport!, context),
          _buildLine5(reportStore.selectingReport!, context),
          _buildLine6(reportStore.selectingReport!, context),
          _buildLine7(reportStore.selectingReport!, context),
          _buildLine8(reportStore.selectingReport!, context),
          _buildLine9(reportStore.selectingReport!, context),
          _buildLine10(reportStore.selectingReport!, context),
          _buildLine11(reportStore.selectingReport!, context),
          _buildLine12(reportStore.selectingReport!, context),
          _buildLine13(reportStore.selectingReport!, context),
        ],
      );
    });
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppTimePicker(
          label: 'observation_time'.i18n(),
          onChanged: (value) => report.observationTime?[widget.index] = value,
          selectedTime: report.observationTime?[widget.index],
          readOnly: widget.readOnly,
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
          readOnly: widget.readOnly,
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
          readOnly: widget.readOnly,
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
          readOnly: widget.readOnly,
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
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'respiration'.i18n(),
        controller: respirationController,
        onChanged: (x) => reportStore
            .selectingReport!.respiration?[widget.index] = int.tryParse(x),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.singleLineFormatter
        ],
        counterText: 'times_per_minute'.i18n(),
        counterColor: Theme.of(context).primaryColor,
        maxLength: 3,
        readOnly: widget.readOnly,
      ),
      AppTextField(
        label: 'pulse'.i18n(),
        controller: pulseController,
        onChanged: (x) =>
            reportStore.selectingReport!.pulse?[widget.index] = int.tryParse(x),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.singleLineFormatter
        ],
        counterText: 'times_per_minute'.i18n(),
        counterColor: Theme.of(context).primaryColor,
        maxLength: 3,
        readOnly: widget.readOnly,
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
                controller: bloodPressureHighController,
                onChanged: (x) => reportStore.selectingReport!
                    .bloodPressureHigh?[widget.index] = int.tryParse(x),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
                readOnly: widget.readOnly,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'blood_pressure_low'.i18n(),
                controller: bloodPressureLowController,
                onChanged: (x) => reportStore.selectingReport!
                    .bloodPressureLow?[widget.index] = int.tryParse(x),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                counterText: 'mmHg'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
                readOnly: widget.readOnly,
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: AppTextField(
                label: 'sp_o2_percent'.i18n(),
                controller: spO2PercentController,
                onChanged: (x) => reportStore.selectingReport!
                    .spO2Percent?[widget.index] = int.tryParse(x),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                counterText: '%'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
                readOnly: widget.readOnly,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'sp_o2_liter'.i18n(),
                controller: spO2LiterController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                onChanged: (value) =>
                    report.spO2Liter?[widget.index] = int.tryParse(value),
                counterText: 'L',
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
                readOnly: widget.readOnly,
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
                controller: pupilRightController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                onChanged: (value) =>
                    report.pupilRight?[widget.index] = int.tryParse(value),
                counterText: 'mm'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
                maxLength: 3,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: AppTextField(
                label: 'pupil_left'.i18n(),
                controller: pupilLeftController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                onChanged: (value) =>
                    report.pupilLeft?[widget.index] = int.tryParse(value),
                counterText: 'mm'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                maxLength: 3,
                readOnly: widget.readOnly,
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
                  readOnly: widget.readOnly,
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
                  readOnly: widget.readOnly,
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
        Focus(
          child: AppTextField(
            label: 'body_temperature'.i18n(),
            controller: bodyTemperatureController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^[0-9]{0,2}(\.[0-9]?)?')),
              FilteringTextInputFormatter.singleLineFormatter,
            ],
            counterText: 'celsius'.i18n(),
            counterColor: Theme.of(context).primaryColor,
            readOnly: widget.readOnly,
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus) return;
            report.bodyTemperature?[widget.index] =
                double.tryParse(bodyTemperatureController.text);
          },
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
          readOnly: widget.readOnly,
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
          controller: hemorrhageController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => report.hemorrhage?[widget.index] = value,
          maxLength: 10,
          readOnly: widget.readOnly,
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
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine7(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppDropdown<bool>(
          items: const [true, false],
          label: 'vomiting'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) => report.vomiting?[widget.index] = value,
          selectedItem: report.vomiting?[widget.index],
          readOnly: widget.readOnly,
        ),
        AppTextField(
          label: 'extremities'.i18n(),
          controller: extremitiesController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => report.extremities?[widget.index] = value,
          maxLength: 10,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine8(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd ==
                  AppConstants.descriptionOfObservationTimeCode)
              .toList(),
          label: 'description_of_observation_time'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) => report.observationTimeDescriptionTypes = report
              .observationTimeDescriptionTypes
              .mapIndexed((i, e) => i == widget.index ? value : e)
              .toList(),
          selectedItem: report.observationTimeDescriptionTypes[widget.index],
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
          readOnly: widget.readOnly,
          fillColor: optionalColor(context),
        ),
        Container(),
      ]);
    });
  }

  Widget _buildLine9(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'each_ecg'.i18n(),
        controller: eachEcgController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.eachEcg?[widget.index] = value,
        maxLength: 10,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
      Focus(
        child: AppTextField(
          label: 'each_oxygen_inhalation'.i18n(),
          controller: eachOxygenInhalationController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'^[0-9]{0,2}(\.[0-9]?)?')),
            FilteringTextInputFormatter.singleLineFormatter,
          ],
          readOnly: widget.readOnly,
          fillColor: optionalColor(context),
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          report.eachOxygenInhalation?[widget.index] =
              double.tryParse(eachOxygenInhalationController.text);
        },
      ),
    ]);
  }

  Widget _buildLine10(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppDropdown<bool>(
          items: const [true, false],
          label: 'each_hemostasis'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) => report.eachHemostasis?[widget.index] = value,
          selectedItem: report.eachHemostasis?[widget.index],
          readOnly: widget.readOnly,
          fillColor: optionalColor(context),
        ),
        AppDropdown<bool>(
          items: const [true, false],
          label: 'each_suction'.i18n(),
          itemAsString: ((item) => formatBool(item) ?? ''),
          onChanged: (value) => report.eachSuction?[widget.index] = value,
          selectedItem: report.eachSuction?[widget.index],
          readOnly: widget.readOnly,
          fillColor: optionalColor(context),
        ),
      ]);
    });
  }

  Widget _buildLine11(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'other_process_1'.i18n(),
        controller: otherProcess1Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherProcess1?[widget.index] = value,
        maxLength: 15,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
      AppTextField(
        label: 'other_process_2'.i18n(),
        controller: otherProcess2Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherProcess2?[widget.index] = value,
        maxLength: 15,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
      AppTextField(
        label: 'other_process_3'.i18n(),
        controller: otherProcess3Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherProcess3?[widget.index] = value,
        maxLength: 15,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
    ]);
  }

  Widget _buildLine12(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'other_process_4'.i18n(),
        controller: otherProcess4Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherProcess4?[widget.index] = value,
        maxLength: 15,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
      AppTextField(
        label: 'other_process_5'.i18n(),
        controller: otherProcess5Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherProcess5?[widget.index] = value,
        maxLength: 15,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
      AppTextField(
        label: 'other_process_6'.i18n(),
        controller: otherProcess6Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherProcess6?[widget.index] = value,
        maxLength: 15,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
    ]);
  }

  Widget _buildLine13(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'other_process_7'.i18n(),
        controller: otherProcess7Controller,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherProcess7?[widget.index] = value,
        maxLength: 15,
        readOnly: widget.readOnly,
        fillColor: optionalColor(context),
      ),
      Container(),
      Container(),
    ]);
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
