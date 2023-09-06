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
  String? editingSpO2Liter;
  String? editingPupilRight;
  String? editingPupilLeft;
  String? editingBodyTemperature;
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
    reportStore.selectingReport!.spO2Percent =
        _ensureLengthObservable(reportStore.selectingReport!.spO2Percent);
    reportStore.selectingReport!.pupilLeft =
        _ensureLengthObservable(reportStore.selectingReport!.pupilLeft);
    reportStore.selectingReport!.pupilRight =
        _ensureLengthObservable(reportStore.selectingReport!.pupilRight);
    reportStore.selectingReport!.bodyTemperature =
        _ensureLengthObservable(reportStore.selectingReport!.bodyTemperature);
    reportStore.selectingReport!.facialFeaturesAnguish =
        _ensureLengthObservable(
            reportStore.selectingReport!.facialFeaturesAnguish);

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
      syncControllerValue(pupilRightController,
          reportStore.selectingReport!.pupilRight?[widget.index]);
      syncControllerValue(pupilLeftController,
          reportStore.selectingReport!.pupilLeft?[widget.index]);
      syncControllerValue(bodyTemperatureController,
          reportStore.selectingReport!.bodyTemperature?[widget.index]);
    });
  }

  @override
  void dispose() {
    if (editingPupilRight != null) {
      reportStore.selectingReport!.pupilRight?[widget.index] =
          double.tryParse(editingPupilRight!);
    }
    if (editingPupilLeft != null) {
      reportStore.selectingReport!.pupilLeft?[widget.index] =
          double.tryParse(editingPupilLeft!);
    }
    if (editingBodyTemperature != null) {
      reportStore.selectingReport!.bodyTemperature?[widget.index] =
          double.tryParse(editingBodyTemperature!);
    }
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
        ],
      );
    });
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTimePicker(
        label: 'observation_time'.i18n(),
        onChanged: (value) => report.observationTime?[widget.index] = value,
        selectedTime: report.observationTime?[widget.index],
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine2(Report report, BuildContext context) {
    return lineLayout(children: [
      Row(
        children: [
          Expanded(
            child: AppDropdown<Classification>(
              items: report.classificationStore!.classifications.values
                  .where((element) =>
                      element.classificationCd == AppConstants.jcsCode)
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
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: AppDropdown<Classification>(
              items: report.classificationStore!.classifications.values
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
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppDropdown<Classification>(
              items: report.classificationStore!.classifications.values
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
          ),
        ],
      ),
    ]);
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return lineLayout(children: [
      Row(
        children: [
          Expanded(
            child: AppTextField(
              label: 'respiration'.i18n(),
              controller: respirationController,
              onChanged: (x) => reportStore.selectingReport!
                  .respiration?[widget.index] = int.tryParse(x),
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
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppTextField(
              label: 'pulse'.i18n(),
              controller: pulseController,
              onChanged: (x) => reportStore
                  .selectingReport!.pulse?[widget.index] = int.tryParse(x),
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
          ),
        ],
      ),
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
            ),
          ),
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
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return lineLayout(children: [
      Row(
        children: [
          Expanded(
            child: AppTextField(
              label: 'sp_o2_percent'.i18n(),
              controller: spO2PercentController,
              onChanged: (x) {
                final result = int.tryParse(x);
                reportStore.selectingReport!.spO2Percent?[widget.index] =
                    result != null && result > 100 ? 100 : result;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.singleLineFormatter
              ],
              counterText: '%'.i18n(),
              counterColor: Theme.of(context).primaryColor,
              maxLength: 3,
              readOnly: widget.readOnly,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: Focus(
              child: AppTextField(
                label: 'pupil_right'.i18n(),
                controller: pupilRightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]{0,2}(\.[0-9]?)?')),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                counterText: 'mm'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
                onChanged: (x) {
                  setState(() {
                    editingPupilRight = x;
                  });
                },
              ),
              onFocusChange: (hasFocus) {
                if (hasFocus) return;
                report.pupilRight?[widget.index] =
                    double.tryParse(pupilRightController.text);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Focus(
              child: AppTextField(
                label: 'pupil_left'.i18n(),
                controller: pupilLeftController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]{0,2}(\.[0-9]?)?')),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                counterText: 'mm'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
                onChanged: (x) {
                  setState(() {
                    editingPupilLeft = x;
                  });
                },
              ),
              onFocusChange: (hasFocus) {
                if (hasFocus) return;
                report.pupilLeft?[widget.index] =
                    double.tryParse(pupilLeftController.text);
              },
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildLine5(Report report, BuildContext context) {
    return lineLayout(children: [
      Row(
        children: [
          Expanded(
            child: Focus(
              child: AppTextField(
                label: 'body_temperature'.i18n(),
                controller: bodyTemperatureController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]{0,2}(\.[0-9]?)?')),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                counterText: 'celsius'.i18n(),
                counterColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly,
                onChanged: (x) {
                  setState(() {
                    editingBodyTemperature = x;
                  });
                },
              ),
              onFocusChange: (hasFocus) {
                if (hasFocus) return;
                report.bodyTemperature?[widget.index] =
                    double.tryParse(bodyTemperatureController.text);
              },
            ),
          ),
        ],
      ),
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
