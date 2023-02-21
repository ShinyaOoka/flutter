import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/widgets/report/section/occurrence_status_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/remarks_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/reporter_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/reporting_status_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/sick_injured_person_info_section.dart';
import 'package:ak_azm_flutter/widgets/report/section/team_info_section.dart';
import 'package:provider/provider.dart';
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
  bool isExpanded;

  _Section({
    required this.widget,
    required this.icon,
    required this.title,
    required this.optional,
    required this.isExpanded,
  });
}

class ReportForm extends StatefulWidget {
  final bool readOnly;
  final bool expanded;
  final bool radio;

  const ReportForm({
    super.key,
    this.readOnly = false,
    this.expanded = false,
    this.radio = true,
  });

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> with ReportSectionMixin {
  late List<_Section> sections;
  late ReportStore _reportStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reportStore = context.read();
    sections = [
      _Section(
        icon: const Icon(Icons.commute),
        title: 'team_info'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: TeamInfoSection(readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.personal_injury),
        title: 'sick_injured_person'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: SickInjuredPersonInfoSection(readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.watch_later),
        title: 'elapsed_time'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: TimeSection(readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.add_location_alt),
        title: 'occurrence_status'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: OccurrenceStatusSection(readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.monitor_heart),
        title: '${"vital_sign".i18n()} 1',
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: VitalSignSection(index: 0, readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.medical_services),
        title: 'treatment'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: TreatmentSection(readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.monitor_heart),
        title: '${"vital_sign".i18n()} 2',
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: VitalSignSection(index: 1, readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.monitor_heart),
        title: '${"vital_sign".i18n()} 3',
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: VitalSignSection(index: 2, readOnly: widget.readOnly)),
        optional: false,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.add_ic_call),
        title: 'reporting_status'.i18n(),
        widget: Container(
          padding: const EdgeInsets.all(16),
          child: ReportingStatusSection(readOnly: widget.readOnly),
        ),
        optional: true,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.airport_shuttle),
        title: 'transport_information'.i18n(),
        widget: Container(
          padding: const EdgeInsets.all(16),
          child: TransportInfoSection(readOnly: widget.readOnly),
        ),
        optional: true,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.account_circle),
        title: 'reporter'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: ReporterSection(readOnly: widget.readOnly)),
        optional: true,
        isExpanded: widget.expanded,
      ),
      _Section(
        icon: const Icon(Icons.article),
        title: 'remarks_section'.i18n(),
        widget: Container(
            padding: const EdgeInsets.all(16),
            child: RemarksSection(readOnly: widget.readOnly)),
        optional: true,
        isExpanded: widget.expanded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.radio) {
      return ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              sections[panelIndex].isExpanded = !isExpanded;
            });
          },
          expandedHeaderPadding: EdgeInsets.zero,
          children: sections
              .asMap()
              .map((index, section) => MapEntry(
                  index,
                  ExpansionPanel(
                      canTapOnHeader: true,
                      backgroundColor: section.optional
                          ? Theme.of(context).secondaryHeaderColor
                          : null,
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                            leading: section.icon,
                            title: Text('${index + 1}. ${section.title}'));
                      },
                      body: section.widget,
                      isExpanded: section.isExpanded)))
              .values
              .toList());
    }
    return ExpansionPanelList.radio(
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            sections[panelIndex].isExpanded = !isExpanded;
          });
        },
        children: sections
            .asMap()
            .map((index, section) => MapEntry(
                index,
                ExpansionPanelRadio(
                    value: index,
                    canTapOnHeader: true,
                    backgroundColor:
                        section.optional ? optionalColor(context) : null,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                          leading: section.icon,
                          title: Text('${index + 1}. ${section.title}'));
                    },
                    body: section.isExpanded ? section.widget : Container())))
            .values
            .toList());
  }
}
