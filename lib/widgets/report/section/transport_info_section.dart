import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/hospital/hospital.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

class TransportInfoSection extends StatefulWidget {
  final bool readOnly;

  const TransportInfoSection({super.key, this.readOnly = false});

  @override
  State<TransportInfoSection> createState() => _TransportInfoSectionState();
}

class _TransportInfoSectionState extends State<TransportInfoSection>
    with ReportSectionMixin {
  final otherReasonForTransferController = TextEditingController();
  final otherReasonForNotTransferringController = TextEditingController();
  final otherMedicalTransportFacilityController = TextEditingController();
  final otherTransferringMedicalInstitutionController = TextEditingController();

  final otherReasonForNotTransferringScrollController = ScrollController();

  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(otherReasonForTransferController,
          reportStore.selectingReport!.otherReasonForTransfer);
      syncControllerValue(otherReasonForNotTransferringController,
          reportStore.selectingReport!.otherReasonForNotTransferring);
      syncControllerValue(otherMedicalTransportFacilityController,
          reportStore.selectingReport!.otherMedicalTransportFacility);
      syncControllerValue(otherTransferringMedicalInstitutionController,
          reportStore.selectingReport!.otherTransferringMedicalInstitution);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    otherReasonForTransferController.dispose();
    otherReasonForNotTransferringController.dispose();
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
          _buildLine3(reportStore.selectingReport!),
          _buildLine4(reportStore.selectingReport!),
          _buildLine5(reportStore.selectingReport!),
          _buildLine6(reportStore.selectingReport!),
          _buildLine7(reportStore.selectingReport!),
          _buildLine8(reportStore.selectingReport!),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppDropdown<Hospital>(
          showSearchBox: true,
          items:
              report.hospitalStore?.hospitals.values.toList().sortedByCompare(
            (e) => Tuple2(e.emergencyMedicineLevel, e.hospitalCd),
            (a, b) {
              final emergencyMedicineLevelCompare =
                  b.item1?.compareTo(a.item1!);
              if (emergencyMedicineLevelCompare == 0) {
                return a.item1!.compareTo(b.item1!);
              }
              return emergencyMedicineLevelCompare ?? -1;
            },
          ),
          label: 'medical_transport_facility'.i18n(),
          itemAsString: ((item) => item.name ?? ''),
          onChanged: (value) {
            report.medicalTransportFacility = value?.hospitalCd;
          },
          selectedItem: report.medicalTransportFacilityType,
          filterFn: (hospital, filter) =>
              (hospital.name != null && hospital.name!.contains(filter)) ||
              (hospital.hospitalCd != null &&
                  hospital.hospitalCd!.contains(filter)),
          readOnly: widget.readOnly,
          optional: true,
        ),
        AppTextField(
          label: 'other_medical_transport_facility'.i18n(),
          controller: otherMedicalTransportFacilityController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => report.otherMedicalTransportFacility = value,
          maxLength: 20,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.multiline,
          optional: true,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppDropdown<Hospital>(
          showSearchBox: true,
          items:
              report.hospitalStore?.hospitals.values.toList().sortedByCompare(
            (e) => Tuple2(e.emergencyMedicineLevel, e.hospitalCd),
            (a, b) {
              final emergencyMedicineLevelCompare =
                  b.item1?.compareTo(a.item1!);
              if (emergencyMedicineLevelCompare == 0) {
                return a.item1!.compareTo(b.item1!);
              }
              return emergencyMedicineLevelCompare ?? -1;
            },
          ),
          label: 'transferring_medical_institution'.i18n(),
          itemAsString: ((item) => item.name ?? ''),
          onChanged: (value) {
            report.transferringMedicalInstitution = value?.hospitalCd;
          },
          selectedItem: report.transferringMedicalInstitutionType,
          filterFn: (hospital, filter) =>
              (hospital.name != null && hospital.name!.contains(filter)) ||
              (hospital.hospitalCd != null &&
                  hospital.hospitalCd!.contains(filter)),
          readOnly: widget.readOnly,
          optional: true,
        ),
        AppTextField(
          label: 'other_transferring_medical_institution'.i18n(),
          controller: otherTransferringMedicalInstitutionController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) =>
              report.otherTransferringMedicalInstitution = value,
          maxLength: 20,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.multiline,
          optional: true,
        ),
      ]);
    });
  }

  Widget _buildLine3(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'transfer_source_receiving_time'.i18n(),
          onChanged: (value) => report.transferSourceReceivingTime = value,
          selectedTime: report.transferSourceReceivingTime,
          readOnly: widget.readOnly,
          optional: true,
        ),
        Container(),
      ]);
    });
  }

  Widget _buildLine4(Report report) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        showSearchBox: true,
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd == AppConstants.reasonForTransferCode)
            .toList(),
        label: 'reason_for_transfer'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.reasonForTransferType = value,
        selectedItem: report.reasonForTransferType,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
        optional: true,
      ),
    ]);
  }

  Widget _buildLine5(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'other_reason_for_transfer'.i18n(),
        controller: otherReasonForTransferController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.otherReasonForTransfer = value,
        maxLength: 60,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        enabled: report.reasonForTransferType?.value == 'その他',
        optional: true,
      ),
    ]);
  }

  Widget _buildLine6(Report report) {
    return lineLayout(children: [
      AppDropdown<Classification>(
        showSearchBox: true,
        items: report.classificationStore!.classifications.values
            .where((element) =>
                element.classificationCd ==
                AppConstants.reasonForNotTransferringCode)
            .toList(),
        label: 'reason_for_not_transferring'.i18n(),
        itemAsString: ((item) => item.value ?? ''),
        onChanged: (value) => report.reasonForNotTransferringType = value,
        selectedItem: report.reasonForNotTransferringType,
        filterFn: (c, filter) =>
            (c.value != null && c.value!.contains(filter)) ||
            (c.classificationSubCd != null &&
                c.classificationSubCd!.contains(filter)),
        readOnly: widget.readOnly,
        optional: true,
      ),
    ]);
  }

  Widget _buildLine7(Report report) {
    return lineLayout(children: [
      Scrollbar(
        thumbVisibility: true,
        controller: otherReasonForNotTransferringScrollController,
        child: AppTextField(
          label: 'other_reason_for_not_transferring'.i18n(),
          controller: otherReasonForNotTransferringController,
          scrollController: otherReasonForNotTransferringScrollController,
          inputFormatters: [maxLineFormatter(7)],
          onChanged: (value) => report.otherReasonForNotTransferring = value,
          maxLength: 100,
          minLines: 3,
          maxLines: 3,
          readOnly: widget.readOnly,
          enabled: report.reasonForNotTransferringType?.value == 'その他',
          optional: true,
        ),
      ),
    ]);
  }

  Widget _buildLine8(Report report) {
    return lineLayout(children: [
      AppDropdown<bool>(
        items: const [true, false],
        label: 'record_of_refusal_of_transfer'.i18n(),
        itemAsString: ((item) => formatBool(item) ?? ''),
        onChanged: (value) {
          report.recordOfRefusalOfTransfer = value;
        },
        selectedItem: report.recordOfRefusalOfTransfer,
        readOnly: widget.readOnly,
        optional: true,
      ),
    ]);
  }
}
