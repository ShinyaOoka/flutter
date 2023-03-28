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
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class ReportingStatusSection extends StatefulWidget {
  final bool readOnly;

  const ReportingStatusSection({super.key, this.readOnly = false});

  @override
  State<ReportingStatusSection> createState() => _ReportingStatusSectionState();
}

class _ReportingStatusSectionState extends State<ReportingStatusSection>
    with ReportSectionMixin {
  final perceiverNameController = TextEditingController();
  final callerNameController = TextEditingController();
  final callerTelController = TextEditingController();
  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(
          perceiverNameController, reportStore.selectingReport!.perceiverName);
      syncControllerValue(
          callerNameController, reportStore.selectingReport!.callerName);
      syncControllerValue(
          callerTelController, reportStore.selectingReport!.callerTel);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    perceiverNameController.dispose();
    callerNameController.dispose();
    callerTelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLine1(reportStore.selectingReport!),
          _buildLine2(reportStore.selectingReport!),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return Observer(builder: (context) {
      final classificationStore = Provider.of<ClassificationStore>(context);
      return lineLayout(children: [
        AppTextField(
          label: 'perceiver_name'.i18n(),
          controller: perceiverNameController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => report.perceiverName = value,
          maxLength: 20,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.multiline,
          optional: true,
        ),
        AppDropdown<Classification>(
          showSearchBox: true,
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
          filterFn: (c, filter) =>
              (c.value != null && c.value!.contains(filter)) ||
              (c.classificationSubCd != null &&
                  c.classificationSubCd!.contains(filter)),
          readOnly: widget.readOnly,
          optional: true,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'caller_name'.i18n(),
        controller: callerNameController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.callerName = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        optional: true,
      ),
      AppTextField(
        label: 'caller_tel'.i18n(),
        controller: callerTelController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9-+]')),
          FilteringTextInputFormatter.singleLineFormatter
        ],
        onChanged: (value) => report.callerTel = value,
        maxLength: 20,
        readOnly: widget.readOnly,
        optional: true,
      ),
    ]);
  }
}
