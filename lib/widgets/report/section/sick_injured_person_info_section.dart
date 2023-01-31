import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jiffy/jiffy.dart';
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

class SickInjuredPersonInfoSection extends StatelessWidget
    with ReportSectionMixin {
  final kanaController = TextEditingController();
  final Report report;

  SickInjuredPersonInfoSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
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
          _buildLine9(report, context),
          _buildLine10(report, context),
        ],
      )
    ]);
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_name'.i18n(),
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
        onChanged: (value) => report.sickInjuredPersonAddress = value,
        maxLength: 60,
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
        ),
        AppDatePicker(
          label: 'sick_injured_person_birth_date'.i18n(),
          selectedDate: report.sickInjuredPersonBirthDate,
          onChanged: (date) {
            report.sickInjuredPersonBirthDate = date;
          },
        ),
      ]);
    });
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_tel'.i18n(),
        keyboardType: TextInputType.phone,
        onChanged: (value) => report.sickInjuredPersonTel = value,
        maxLength: 20,
      ),
      AppTextField(
        label: 'sick_injured_person_family_tel'.i18n(),
        keyboardType: TextInputType.phone,
        onChanged: (value) => report.sickInjuredPersonFamilyTel = value,
        maxLength: 20,
      ),
    ]);
  }

  Widget _buildLine5(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_medical_history'.i18n(),
        onChanged: (value) => report.sickInjuredPersonMedicalHistory = value,
        maxLength: 20,
      ),
      AppTextField(
        label: 'sick_injured_person_history_hospital'.i18n(),
        onChanged: (value) => report.sickInjuredPersonHistoryHospital = value,
        maxLength: 20,
      ),
    ]);
  }

  Widget _buildLine6(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTextField(
        label: 'sick_injured_person_kakaritsuke'.i18n(),
        onChanged: (value) => report.sickInjuredPersonKakaritsuke = value,
        maxLength: 20,
      ),
      AppTextField(
        label: 'sick_injured_person_allergy'.i18n(),
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
        ),
        AppTextField(
          label: 'sick_injured_person_medication_detail'.i18n(),
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
            onChanged: (value) =>
                report.sickInjuredPersonNameOfInjuryOrSickness = value,
            maxLength: 60,
          ),
          context: context),
    ]);
  }

  Widget _buildLine9(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        optional(
            child: AppTextField(
              label: 'sick_injured_person_degree'.i18n(),
              controller:
                  TextEditingController(text: report.sickInjuredPersonDegree),
              maxLength: 60,
            ),
            context: context),
      ]);
    });
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
