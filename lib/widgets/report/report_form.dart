import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:collection/collection.dart';
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
  final GlobalKey globalKey = GlobalKey();

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
  ScrollController scrollController = ScrollController();

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

  Widget buildContent(BuildContext context) {
    return ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) async {
          setState(() {
            sections.forEachIndexed((index, element) {
              if (index == panelIndex) {
                sections[index].isExpanded = !isExpanded;
              } else if (widget.radio) {
                sections[index].isExpanded = false;
              }
            });
          });
          if (widget.radio) {
            await Future.delayed(const Duration(milliseconds: 300), () async {
              await Scrollable.ensureVisible(
                  sections[panelIndex].globalKey.currentContext!,
                  duration: const Duration(milliseconds: 200));
              // Make sure that if the previous call didn't scroll the widget to
              // top, maybe because of an animation jitter, scroll it immediately
              // to the top
              await Scrollable.ensureVisible(
                  sections[panelIndex].globalKey.currentContext!,
                  duration: const Duration(milliseconds: 0));
            });
          }
        },
        animationDuration: const Duration(milliseconds: 200),
        expandedHeaderPadding: EdgeInsets.zero,
        children: sections
            .asMap()
            .map((index, section) => MapEntry(
                index,
                ExpansionPanel(
                    canTapOnHeader: true,
                    backgroundColor: Color(0xFFF5F5F5),
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        key: section.globalKey,
                        leading: section.icon,
                        title: section.optional
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${index + 1}. ${section.title}'),
                                  const SizedBox(width: 8),
                                  Container(
                                    color: Colors.green,
                                    padding: const EdgeInsets.only(
                                      left: 6 * 0.75,
                                      right: 6 * 0.75,
                                      top: 2 * 1,
                                      bottom: 2 * 0.5,
                                    ),
                                    child: const Text(
                                      '報告',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12 * 0.75,
                                        height: 1,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Text('${index + 1}. ${section.title}'),
                      );
                    },
                    body: section.isExpanded ? section.widget : Container(),
                    isExpanded: section.isExpanded)))
            .values
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        child: buildContent(context),
      ),
    );
  }
}
