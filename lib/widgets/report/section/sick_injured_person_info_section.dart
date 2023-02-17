import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jiffy/jiffy.dart';
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
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class SickInjuredPersonInfoSection extends StatefulWidget {
  final Report report;
  final bool readOnly;

  const SickInjuredPersonInfoSection(
      {super.key, required this.report, this.readOnly = false});

  @override
  State<SickInjuredPersonInfoSection> createState() =>
      _SickInjuredPersonInfoSectionState();
}

class _SickInjuredPersonInfoSectionState
    extends State<SickInjuredPersonInfoSection> with ReportSectionMixin {
  final kanaController = TextEditingController();
  final sickInjuredPersonNameController = TextEditingController();
  final sickInjuredPersonAddressController = TextEditingController();
  final sickInjuredPersonTelController = TextEditingController();
  final sickInjuredPersonFamilyTelController = TextEditingController();
  final sickInjuredPersonMedicalHistoryController = TextEditingController();
  final sickInjuredPersonHistoryHospitalController = TextEditingController();
  final sickInjuredPersonKakaritsukeController = TextEditingController();
  final sickInjuredPersonAllergyController = TextEditingController();
  final sickInjuredPersonMedicationDetailController = TextEditingController();
  final sickInjuredPersonNameOfInjuryOrSicknessController =
      TextEditingController();
  final sickInjuredPersonDegreeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    autorun((_) {
      syncControllerValue(
          sickInjuredPersonNameController, widget.report.sickInjuredPersonName);
      syncControllerValue(sickInjuredPersonAddressController,
          widget.report.sickInjuredPersonAddress);
      syncControllerValue(
          sickInjuredPersonTelController, widget.report.sickInjuredPersonTel);
      syncControllerValue(sickInjuredPersonFamilyTelController,
          widget.report.sickInjuredPersonFamilyTel);
      syncControllerValue(sickInjuredPersonMedicalHistoryController,
          widget.report.sickInjuredPersonMedicalHistory);
      syncControllerValue(sickInjuredPersonHistoryHospitalController,
          widget.report.sickInjuredPersonHistoryHospital);
      syncControllerValue(sickInjuredPersonKakaritsukeController,
          widget.report.sickInjuredPersonKakaritsuke);
      syncControllerValue(sickInjuredPersonAllergyController,
          widget.report.sickInjuredPersonAllergy);
      syncControllerValue(sickInjuredPersonMedicationDetailController,
          widget.report.sickInjuredPersonMedicationDetail);
      syncControllerValue(sickInjuredPersonNameOfInjuryOrSicknessController,
          widget.report.sickInjuredPersonNameOfInjuryOrSickness);
      syncControllerValue(sickInjuredPersonDegreeController,
          widget.report.sickInjuredPersonDegree);
    });
  }

  @override
  void dispose() {
    kanaController.dispose();
    sickInjuredPersonNameController.dispose();
    sickInjuredPersonAddressController.dispose();
    sickInjuredPersonTelController.dispose();
    sickInjuredPersonFamilyTelController.dispose();
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
    return Stack(children: [
      Column(
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
          _buildLine9(widget.report, context),
          _buildLine10(widget.report, context),
        ],
      )
    ]);
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_name'.i18n(),
        controller: sickInjuredPersonNameController,
        onChanged: (value) => report.sickInjuredPersonName = value,
        maxLength: 20,
      ),
      Focus(
        child: AppTextField(
          label: 'sick_injured_person_kana'.i18n(),
          controller: kanaController,
          maxLength: 20,
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;
          report.sickInjuredPersonKana = RegExp(r'^([ァ-ン]|ー)+')
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
      AppTextField(
        label: 'sick_injured_person_address'.i18n(),
        hintText: '〇〇県△△市□□NN-NN-NN',
        controller: sickInjuredPersonAddressController,
        onChanged: (value) => report.sickInjuredPersonAddress = value,
        maxLength: 60,
        maxLines: 1,
      ),
    ]);
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
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
        ),
        AppDatePicker(
          label: 'sick_injured_person_birth_date'.i18n(),
          selectedDate: report.sickInjuredPersonBirthDate,
          onChanged: (date) {
            report.sickInjuredPersonBirthDate = date;
          },
          maxTime: DateTime.now(),
        ),
      ]);
    });
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_tel'.i18n(),
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-+]'))],
        controller: sickInjuredPersonTelController,
        onChanged: (value) => report.sickInjuredPersonTel = value,
        maxLength: 20,
      ),
      AppTextField(
        label: 'sick_injured_person_family_tel'.i18n(),
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-+]'))],
        controller: sickInjuredPersonFamilyTelController,
        onChanged: (value) => report.sickInjuredPersonFamilyTel = value,
        maxLength: 20,
      ),
    ]);
  }

  Widget _buildLine5(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_medical_history'.i18n(),
        controller: sickInjuredPersonMedicalHistoryController,
        onChanged: (value) => report.sickInjuredPersonMedicalHistory = value,
        maxLength: 20,
      ),
      AppTextField(
        label: 'sick_injured_person_history_hospital'.i18n(),
        controller: sickInjuredPersonHistoryHospitalController,
        onChanged: (value) => report.sickInjuredPersonHistoryHospital = value,
        maxLength: 20,
      ),
    ]);
  }

  Widget _buildLine6(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_kakaritsuke'.i18n(),
        controller: sickInjuredPersonKakaritsukeController,
        onChanged: (value) => report.sickInjuredPersonKakaritsuke = value,
        maxLength: 20,
      ),
      AppTextField(
        label: 'sick_injured_person_allergy'.i18n(),
        controller: sickInjuredPersonAllergyController,
        onChanged: (value) => report.sickInjuredPersonAllergy = value,
        maxLength: 20,
      ),
    ]);
  }

  Widget _buildLine7(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
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
        ),
        AppTextField(
          label: 'sick_injured_person_medication_detail'.i18n(),
          controller: sickInjuredPersonMedicationDetailController,
          onChanged: (value) =>
              report.sickInjuredPersonMedicationDetail = value,
          maxLength: 20,
        ),
      ]);
    });
  }

  Widget _buildLine8(Report report, BuildContext context) {
    return lineLayout(children: [
      optional(
          child: AppTextField(
            label: 'sick_injured_person_name_of_injury_or_sickness'.i18n(),
            controller: sickInjuredPersonNameOfInjuryOrSicknessController,
            onChanged: (value) =>
                report.sickInjuredPersonNameOfInjuryOrSickness = value,
            maxLength: 60,
            maxLines: 1,
          ),
          context: context),
    ]);
  }

  Widget _buildLine9(Report report, BuildContext context) {
    return lineLayout(children: [
      optional(
          child: AppTextField(
            label: 'sick_injured_person_degree'.i18n(),
            controller: sickInjuredPersonDegreeController,
            onChanged: (value) => report.sickInjuredPersonDegree = value,
            maxLength: 60,
            maxLines: 1,
          ),
          context: context),
    ]);
  }

  Widget _buildLine10(Report report, BuildContext context) {
    return Observer(builder: (context) {
      int? age;
      if (report.dateOfOccurrence != null &&
          report.sickInjuredPersonBirthDate != null) {
        age = Jiffy(report.dateOfOccurrence)
            .diff(report.sickInjuredPersonBirthDate, Units.YEAR)
            .toInt();
      }
      return lineLayout(children: [
        optional(
            child: AppTextField(
              label: 'sick_injured_person_age'.i18n(),
              controller: TextEditingController(text: age?.toString()),
              enabled: false,
            ),
            context: context),
      ]);
    });
  }
}
