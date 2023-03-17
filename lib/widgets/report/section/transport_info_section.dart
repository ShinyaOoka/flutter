import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/hospital/hospital.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/hospital/hospital_store.dart';
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
  final reasonForTransferController = TextEditingController();
  final reasonForNotTransferringController = TextEditingController();
  final otherMedicalTransportFacilityController = TextEditingController();
  final otherTransferringMedicalInstitutionController = TextEditingController();
  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(reasonForTransferController,
          reportStore.selectingReport!.reasonForTransfer);
      syncControllerValue(reasonForNotTransferringController,
          reportStore.selectingReport!.reasonForNotTransferring);
      syncControllerValue(otherMedicalTransportFacilityController,
          reportStore.selectingReport!.otherMedicalTransportFacility);
      syncControllerValue(otherTransferringMedicalInstitutionController,
          reportStore.selectingReport!.otherTransferringMedicalInstitution);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    reasonForTransferController.dispose();
    reasonForNotTransferringController.dispose();
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
        ),
        AppTextField(
          label: 'other_medical_transport_facility'.i18n(),
          controller: otherMedicalTransportFacilityController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) => report.otherMedicalTransportFacility = value,
          maxLength: 20,
          maxLines: 1,
          readOnly: widget.readOnly,
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
        ),
        AppTextField(
          label: 'other_transferring_medical_institution'.i18n(),
          controller: otherTransferringMedicalInstitutionController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (value) =>
              report.otherTransferringMedicalInstitution = value,
          maxLength: 20,
          maxLines: 1,
          readOnly: widget.readOnly,
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
        ),
        Container(),
      ]);
    });
  }

  Widget _buildLine4(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'reason_for_transfer'.i18n(),
        controller: reasonForTransferController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        onChanged: (value) => report.reasonForTransfer = value,
        maxLength: 60,
        maxLines: 1,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine5(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'reason_for_not_transferring'.i18n(),
        controller: reasonForNotTransferringController,
        inputFormatters: [maxLineFormatter(7)],
        onChanged: (value) => report.reasonForNotTransferring = value,
        maxLength: 100,
        minLines: 3,
        maxLines: 3,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine6(Report report) {
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
      ),
    ]);
  }
}
