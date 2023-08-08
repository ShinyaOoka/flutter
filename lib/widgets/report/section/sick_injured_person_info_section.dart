import 'package:ak_azm_flutter/stores/report/report_store.dart';
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
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class SickInjuredPersonInfoSection extends StatefulWidget {
  final bool readOnly;

  const SickInjuredPersonInfoSection({super.key, this.readOnly = false});

  @override
  State<SickInjuredPersonInfoSection> createState() =>
      _SickInjuredPersonInfoSectionState();
}

class _SickInjuredPersonInfoSectionState
    extends State<SickInjuredPersonInfoSection> with ReportSectionMixin {
  String? editingPersonKana;
  final kanaController = TextEditingController();
  final sickInjuredPersonNameController = TextEditingController();
  final sickInjuredPersonAddressController = TextEditingController();
  final sickInjuredPersonTelController = TextEditingController();
  final sickInjuredPersonFamilyController = TextEditingController();
  final sickInjuredPersonFamilyTelController = TextEditingController();
  final sickInjuredPersonMedicalHistoryController = TextEditingController();
  final sickInjuredPersonHistoryHospitalController = TextEditingController();
  final sickInjuredPersonKakaritsukeController = TextEditingController();
  final sickInjuredPersonAllergyController = TextEditingController();
  final sickInjuredPersonMedicationDetailController = TextEditingController();
  final sickInjuredPersonNameOfInjuryOrSicknessController =
      TextEditingController();
  final sickInjuredPersonDegreeController = TextEditingController();

  final sickInjuredPersonAddressScrollController = ScrollController();

  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    autorun((_) {
      syncControllerValue(
          kanaController, reportStore.selectingReport!.sickInjuredPersonKana);
      syncControllerValue(sickInjuredPersonNameController,
          reportStore.selectingReport!.sickInjuredPersonName);
      syncControllerValue(sickInjuredPersonAddressController,
          reportStore.selectingReport!.sickInjuredPersonAddress);
      syncControllerValue(sickInjuredPersonTelController,
          reportStore.selectingReport!.sickInjuredPersonTel);
      syncControllerValue(sickInjuredPersonFamilyTelController,
          reportStore.selectingReport!.sickInjuredPersonFamilyTel);
      syncControllerValue(sickInjuredPersonFamilyController,
          reportStore.selectingReport!.sickInjuredPersonFamily);
      syncControllerValue(sickInjuredPersonMedicalHistoryController,
          reportStore.selectingReport!.sickInjuredPersonMedicalHistory);
      syncControllerValue(sickInjuredPersonHistoryHospitalController,
          reportStore.selectingReport!.sickInjuredPersonHistoryHospital);
      syncControllerValue(sickInjuredPersonKakaritsukeController,
          reportStore.selectingReport!.sickInjuredPersonKakaritsuke);
      syncControllerValue(sickInjuredPersonAllergyController,
          reportStore.selectingReport!.sickInjuredPersonAllergy);
      syncControllerValue(sickInjuredPersonMedicationDetailController,
          reportStore.selectingReport!.sickInjuredPersonMedicationDetail);
      syncControllerValue(sickInjuredPersonNameOfInjuryOrSicknessController,
          reportStore.selectingReport!.sickInjuredPersonNameOfInjuryOrSickness);
      syncControllerValue(sickInjuredPersonDegreeController,
          reportStore.selectingReport!.sickInjuredPersonDegree);
    });
  }

  @override
  void dispose() {
    kanaController.dispose();
    sickInjuredPersonNameController.dispose();
    sickInjuredPersonAddressController.dispose();
    sickInjuredPersonTelController.dispose();
    sickInjuredPersonFamilyTelController.dispose();
    sickInjuredPersonFamilyController.dispose();
    sickInjuredPersonMedicalHistoryController.dispose();
    sickInjuredPersonHistoryHospitalController.dispose();
    sickInjuredPersonKakaritsukeController.dispose();
    sickInjuredPersonAllergyController.dispose();
    sickInjuredPersonMedicationDetailController.dispose();
    sickInjuredPersonNameOfInjuryOrSicknessController.dispose();
    sickInjuredPersonDegreeController.dispose();
    super.dispose();
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
        ],
      );
    });
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_name'.i18n(),
        controller: sickInjuredPersonNameController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.sickInjuredPersonName = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
      Focus(
        child: AppTextField(
          label: 'sick_injured_person_kana'.i18n(),
          controller: kanaController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          maxLength: 20,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.multiline,
          onChanged: (x) {
            setState(() {
              editingPersonKana = x;
            });
          },
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          report.sickInjuredPersonKana = RegExp(r'([ァ-ン]|ー| |　)+')
              .allMatches(kanaController.text)
              .map((x) => x.group(0))
              .join();
          kanaController.text = report.sickInjuredPersonKana ?? '';
        },
      ),
    ]);
  }

  Widget _buildLine2(Report report, BuildContext context) {
    return lineLayout(children: [
      Scrollbar(
        controller: sickInjuredPersonAddressScrollController,
        thumbVisibility: true,
        child: AppTextField(
          label: 'sick_injured_person_address'.i18n(),
          hintText: '〇〇県△△市□□NN-NN-NN',
          controller: sickInjuredPersonAddressController,
          scrollController: sickInjuredPersonAddressScrollController,
          onChanged: (value) => report.sickInjuredPersonAddress = value,
          inputFormatters: [maxLineFormatter(4)],
          keyboardType: TextInputType.multiline,
          maxLength: 60,
          maxLines: 3,
          readOnly: widget.readOnly,
        ),
      ),
    ]);
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return lineLayout(children: [
      AppDatePicker(
        label: 'sick_injured_person_birth_date'.i18n(),
        selectedDate: report.sickInjuredPersonBirthDate,
        onChanged: (date) {
          report.sickInjuredPersonBirthDate = date;
        },
        maxTime: DateTime.now(),
        readOnly: widget.readOnly,
        defaultDate: DateTime(1970, 1, 1),
      ),
      Row(
        children: [
          Expanded(
            child: AppTextField(
              label: 'sick_injured_person_japanese_birth_year'.i18n(),
              controller: TextEditingController(
                  text: report.sickInjuredPersonBirthDate != null
                      ? '${yearToWareki(report.sickInjuredPersonBirthDate!.year, report.sickInjuredPersonBirthDate!.month, report.sickInjuredPersonBirthDate!.day)}年'
                      : ''),
              readOnly: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppTextField(
              label: 'sick_injured_person_age'.i18n(),
              controller: TextEditingController(
                  text: report.sickInjuredPersonAge?.toString()),
              readOnly: true,
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd == AppConstants.genderCode)
            .toList(),
        label: 'sick_injured_person_gender'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.gender = value,
        selectedItem: report.gender,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
      ),
      AppTextField(
        label: 'sick_injured_person_tel'.i18n(),
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-+]'))],
        controller: sickInjuredPersonTelController,
        onChanged: (value) => report.sickInjuredPersonTel = value,
        maxLength: 20,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine5(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_family'.i18n(),
        controller: sickInjuredPersonFamilyController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.sickInjuredPersonFamily = value,
        maxLength: 10,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
      AppTextField(
        label: 'sick_injured_person_family_tel'.i18n(),
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9-+]')),
          FilteringTextInputFormatter.singleLineFormatter
        ],
        controller: sickInjuredPersonFamilyTelController,
        onChanged: (value) => report.sickInjuredPersonFamilyTel = value,
        maxLength: 20,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine6(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_medical_history'.i18n(),
        controller: sickInjuredPersonMedicalHistoryController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.sickInjuredPersonMedicalHistory = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
      AppTextField(
        label: 'sick_injured_person_history_hospital'.i18n(),
        controller: sickInjuredPersonHistoryHospitalController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.sickInjuredPersonHistoryHospital = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
    ]);
  }

  Widget _buildLine7(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_kakaritsuke'.i18n(),
        controller: sickInjuredPersonKakaritsukeController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.sickInjuredPersonKakaritsuke = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
      AppTextField(
        label: 'sick_injured_person_allergy'.i18n(),
        controller: sickInjuredPersonAllergyController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.sickInjuredPersonAllergy = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
    ]);
  }

  Widget _buildLine8(Report report, BuildContext context) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd == AppConstants.medicationCode)
            .toList(),
        label: 'sick_injured_person_medication'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.medication = value,
        selectedItem: report.medication,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
      ),
      AppTextField(
        label: 'sick_injured_person_medication_detail'.i18n(),
        controller: sickInjuredPersonMedicationDetailController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.sickInjuredPersonMedicationDetail = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
      ),
    ]);
  }

  Widget _buildLine9(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_name_of_injury_or_sickness'.i18n(),
        controller: sickInjuredPersonNameOfInjuryOrSicknessController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) =>
            report.sickInjuredPersonNameOfInjuryOrSickness = value,
        maxLength: 60,
        readOnly: widget.readOnly,
        optional: true,
        keyboardType: TextInputType.multiline,
      ),
    ]);
  }

  Widget _buildLine10(Report report, BuildContext context) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd == AppConstants.degreeCode)
            .toList(),
        label: 'sick_injured_person_degree'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.degree = value,
        selectedItem: report.degree,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
        optional: true,
      ),
    ]);
  }
}
