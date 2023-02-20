import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
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

class TransportInfoSection extends StatefulWidget {
  final bool readOnly;

  TransportInfoSection({super.key, this.readOnly = false});

  @override
  State<TransportInfoSection> createState() => _TransportInfoSectionState();
}

class _TransportInfoSectionState extends State<TransportInfoSection>
    with ReportSectionMixin {
  final reasonForTransferController = TextEditingController();
  final reasonForNotTransferringController = TextEditingController();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(reportStore.selectingReport!),
        _buildLine2(reportStore.selectingReport!),
        _buildLine3(reportStore.selectingReport!),
        _buildLine4(reportStore.selectingReport!),
        _buildLine5(reportStore.selectingReport!),
      ],
    );
  }

  Widget _buildLine1(Report report) {
    return Observer(builder: (context) {
      final hospitalStore = Provider.of<HospitalStore>(context);
      final selectedMedicalTransportFacility =
          hospitalStore.hospitals?.toList().firstWhereOrNull(
                (element) =>
                    element.hospitalCd == report.medicalTransportFacility,
              );
      final selectedTransferringMedicalInstitution =
          hospitalStore.hospitals?.toList().firstWhereOrNull(
                (element) =>
                    element.hospitalCd == report.transferringMedicalInstitution,
              );
      return lineLayout(children: [
        AppDropdown<Hospital>(
          showSearchBox: true,
          items: hospitalStore.hospitals?.toList(),
          label: 'medical_transport_facility'.i18n(),
          itemAsString: ((item) => item.name ?? ''),
          onChanged: (value) {
            report.medicalTransportFacility = value?.hospitalCd;
          },
          selectedItem: selectedMedicalTransportFacility,
          filterFn: (hospital, filter) =>
              (hospital.name != null && hospital.name!.contains(filter)) ||
              (hospital.hospitalCd != null &&
                  hospital.hospitalCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
        AppDropdown<Hospital>(
          showSearchBox: true,
          items: hospitalStore.hospitals?.toList(),
          label: 'transferring_medical_institution'.i18n(),
          itemAsString: ((item) => item.name ?? ''),
          onChanged: (value) {
            report.transferringMedicalInstitution = value?.hospitalCd;
          },
          selectedItem: selectedTransferringMedicalInstitution,
          filterFn: (hospital, filter) =>
              (hospital.name != null && hospital.name!.contains(filter)) ||
              (hospital.hospitalCd != null &&
                  hospital.hospitalCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'transfer_source_receiving_time'.i18n(),
          onChanged: (value) => report.transferSourceReceivingTime = value,
          selectedTime: report.transferSourceReceivingTime,
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine3(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'reason_for_transfer'.i18n(),
        onChanged: (value) => report.reasonForTransfer = value,
        maxLength: 60,
        maxLines: 1,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine4(Report report) {
    return lineLayout(children: [
      AppTextField(
        label: 'reason_for_not_transferring'.i18n(),
        onChanged: (value) => report.reasonForNotTransferring = value,
        maxLength: 100,
        minLines: 3,
        readOnly: widget.readOnly,
      ),
    ]);
  }

  Widget _buildLine5(Report report) {
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
