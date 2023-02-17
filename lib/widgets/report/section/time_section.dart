import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class TimeSection extends StatelessWidget with ReportSectionMixin {
  final Report report;
  final bool readOnly;

  TimeSection({super.key, required this.report, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLine1(report, context),
        _buildLine2(report, context),
        _buildLine3(report, context),
        _buildLine4(report, context),
      ],
    );
  }

  Widget _buildLine1(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'sense_time'.i18n(),
          onChanged: (value) => report.senseTime = value,
          selectedTime: report.senseTime,
        ),
        AppTimePicker(
          label: 'command_time'.i18n(),
          onChanged: (value) => report.commandTime = value,
          selectedTime: report.commandTime,
        ),
        AppTimePicker(
          label: 'attendence_time'.i18n(),
          onChanged: (value) => report.attendanceTime = value,
          selectedTime: report.attendanceTime,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'on_site_arrival_time'.i18n(),
          onChanged: (value) => report.onSiteArrivalTime = value,
          selectedTime: report.onSiteArrivalTime,
        ),
        AppTimePicker(
          label: 'contact_time'.i18n(),
          onChanged: (value) => report.contactTime = value,
          selectedTime: report.contactTime,
        ),
        AppTimePicker(
          label: 'in_vehicle_time'.i18n(),
          onChanged: (value) => report.inVehicleTime = value,
          selectedTime: report.inVehicleTime,
        ),
      ]);
    });
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'start_of_transport_time'.i18n(),
          onChanged: (value) => report.startOfTransportTime = value,
          selectedTime: report.startOfTransportTime,
        ),
        AppTimePicker(
          label: 'hospital_arrival_time'.i18n(),
          onChanged: (value) => report.hospitalArrivalTime = value,
          selectedTime: report.hospitalArrivalTime,
        ),
        AppTimePicker(
          label: 'family_contact_time'.i18n(),
          onChanged: (value) => report.familyContactTime = value,
          selectedTime: report.familyContactTime,
        ),
      ]);
    });
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTimePicker(
          label: 'police_contact_time'.i18n(),
          onChanged: (value) => report.policeContactTime = value,
          selectedTime: report.policeContactTime,
        ),
        optional(
          child: AppTimePicker(
            label: 'time_of_arrival'.i18n(),
            onChanged: (value) => report.timeOfArrival = value,
            selectedTime: report.timeOfArrival,
          ),
          context: context,
        ),
        optional(
          child: AppTimePicker(
            label: 'return_time'.i18n(),
            onChanged: (value) => report.returnTime = value,
            selectedTime: report.returnTime,
          ),
          context: context,
        ),
      ]);
    });
  }
}
