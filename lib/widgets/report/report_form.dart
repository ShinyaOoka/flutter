import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/report/section/occurrence_status_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/remarks_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/reporter_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/reporting_status_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/sick_injured_person_info_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/team_info_section.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/time_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/transport_info_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/treatment_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/vital_sign_section.dart';

class _Section {
  final Widget widget;
  final String title;
  final Widget icon;
  final bool optional;

  _Section(
      {required this.widget,
      required this.icon,
      required this.title,
      required this.optional});
}

class ReportForm extends StatelessWidget {
  final Report report;
  late final List<_Section> _sections;

  ReportForm({super.key, required this.report}) {
    _sections = [
      _Section(
        icon: const Icon(Icons.commute),
        title: 'team_info'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: TeamInfoSection(report: report)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.personal_injury),
        title: 'sick_injured_person'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: SickInjuredPersonInfoSection(report: report)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.watch_later),
        title: 'elapsed_time'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: TimeSection(report: report)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.add_location_alt),
        title: 'occurrence_status'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: OccurrenceStatusSection(report: report)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.monitor_heart),
        title: '${"vital_sign".i18n()} 1',
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: VitalSignSection(report: report, index: 0)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.medical_services),
        title: 'treatment'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: TreatmentSection(report: report)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.monitor_heart),
        title: '${"vital_sign".i18n()} 2',
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: VitalSignSection(report: report, index: 1)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.monitor_heart),
        title: '${"vital_sign".i18n()} 3',
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: VitalSignSection(report: report, index: 2)),
        optional: false,
      ),
      _Section(
        icon: const Icon(Icons.add_ic_call),
        title: 'reporting_status'.i18n(),
        widget: Container(
          padding: const EdgeInsets.all(16),
          child: ReportingStatusSection(report: report),
        ),
        optional: true,
      ),
      _Section(
        icon: const Icon(Icons.airport_shuttle),
        title: 'transport_information'.i18n(),
        widget: Container(
          padding: const EdgeInsets.all(16),
          child: TransportInfoSection(report: report),
        ),
        optional: true,
      ),
      _Section(
        icon: const Icon(Icons.account_circle),
        title: 'reporter'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: ReporterSection(report: report)),
        optional: true,
      ),
      _Section(
        icon: const Icon(Icons.article),
        title: 'remarks_section'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: RemarksSection(report: report)),
        optional: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (panelIndex, isExpanded) {},
            children: _sections
                .asMap()
                .map((index, section) => MapEntry(
                    index,
                    ExpansionPanelRadio(
                        value: index,
                        canTapOnHeader: true,
                        backgroundColor: section.optional
                            ? Theme.of(context).secondaryHeaderColor
                            : null,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                              leading: section.icon,
                              title: Text('${index + 1}. ${section.title}'));
                        },
                        body: section.widget)))
                .values
                .toList()));
  }
}
