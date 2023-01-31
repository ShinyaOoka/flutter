import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class ReportingStatusSection extends StatelessWidget with ReportSectionMixin {
  final Report report;

  ReportingStatusSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(report),
        _buildLine2(report),
      ],
    );
  }

  Widget _buildLine1(Report report) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppTextField(
          label: 'perceiver_name'.i18n(),
          onChanged: (value) => report.perceiverName = value,
          maxLength: 20,
        ),
        AppDropdown<Classification>(
          items: classificationStore.classifications.values
              .where((element) =>
                  element.classificationCd == AppConstants.typeOfDetectionCode)
              .toList(),
          label: 'type_of_detection'.i18n(),
          itemAsString: ((item) => item.value ?? ''),
          onChanged: (value) {
            report.detectionType = value;
          },
          selectedItem: report.detectionType,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'caller_name'.i18n(),
        onChanged: (value) => report.callerName = value,
        maxLength: 20,
      ),
      AppTextField(
        label: 'caller_tel'.i18n(),
        onChanged: (value) => report.callerTel = value,
        maxLength: 20,
      ),
    ]);
  }
}
