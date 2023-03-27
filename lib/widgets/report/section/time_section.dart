import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:provider/provider.dart';

class TimeSection extends StatefulWidget {
  final bool readOnly;

  const TimeSection({super.key, this.readOnly = false});

  @override
  State<TimeSection> createState() => _TimeSectionState();
}

class _TimeSectionState extends State<TimeSection> with ReportSectionMixin {
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
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
        ],
      );
    });
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'sense_time'.i18n(),
          onChanged: (value) => report.senseTime = value,
          selectedTime: report.senseTime,
          readOnly: widget.readOnly,
        ),
        AppTimePicker(
          label: 'command_time'.i18n(),
          onChanged: (value) => report.commandTime = value,
          selectedTime: report.commandTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
        AppTimePicker(
          label: 'dispatch_time'.i18n(),
          onChanged: (value) => report.dispatchTime = value,
          selectedTime: report.dispatchTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
        AppTimePicker(
          label: 'on_site_arrival_time'.i18n(),
          onChanged: (value) => report.onSiteArrivalTime = value,
          selectedTime: report.onSiteArrivalTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'in_vehicle_time'.i18n(),
          onChanged: (value) => report.inVehicleTime = value,
          selectedTime: report.inVehicleTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
        AppTimePicker(
          label: 'start_of_transport_time'.i18n(),
          onChanged: (value) => report.startOfTransportTime = value,
          selectedTime: report.startOfTransportTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
        AppTimePicker(
          label: 'hospital_arrival_time'.i18n(),
          onChanged: (value) => report.hospitalArrivalTime = value,
          selectedTime: report.hospitalArrivalTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
        Container()
      ]);
    });
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppCheckbox(
          label: 'family_contact'.i18n(),
          value: report.familyContact,
          onChanged: (value) => report.familyContact = value,
          readOnly: widget.readOnly,
        ),
        AppTimePicker(
          label: 'family_contact_time'.i18n(),
          onChanged: (value) => report.familyContactTime = value,
          selectedTime: report.familyContactTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
        AppCheckbox(
          label: 'police_contact'.i18n(),
          value: report.policeContact,
          onChanged: (value) => report.policeContact = value,
          readOnly: widget.readOnly,
        ),
        AppTimePicker(
          label: 'police_contact_time'.i18n(),
          onChanged: (value) => report.policeContactTime = value,
          selectedTime: report.policeContactTime,
          readOnly: widget.readOnly,
          defaultTime: report.senseTime,
        ),
      ]);
    });
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return lineLayout(children: [
      AppTimePicker(
        label: 'time_of_arrival'.i18n(),
        onChanged: (value) => report.timeOfArrival = value,
        selectedTime: report.timeOfArrival,
        readOnly: widget.readOnly,
        optional: true,
        defaultTime: report.senseTime,
      ),
      AppTimePicker(
        label: 'return_time'.i18n(),
        onChanged: (value) => report.returnTime = value,
        selectedTime: report.returnTime,
        readOnly: widget.readOnly,
        optional: true,
        defaultTime: report.senseTime,
      ),
      Container(),
      Container(),
    ]);
  }
}
