import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/stores/team_member/team_member_store.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class ReporterSection extends StatefulWidget {
  final bool readOnly;

  const ReporterSection({super.key, this.readOnly = false});

  @override
  State<ReporterSection> createState() => _ReporterSectionState();
}

class _ReporterSectionState extends State<ReporterSection>
    with ReportSectionMixin {
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
          _buildLine1(reportStore.selectingReport!),
          _buildLine2(reportStore.selectingReport!),
        ],
      );
    });
  }

  Widget _buildLine1(Report report) {
    return Observer(builder: (context) {
      final teamMemberStore = Provider.of<TeamMemberStore>(context);
      final teamStore = Provider.of<TeamStore>(context);
      final selectedReporterTeam = teamStore.teams[report.reporter?.teamCd];
      return lineLayout(children: [
        AppDropdown(
          showSearchBox: true,
          items: teamMemberStore.teamMembers.values.toList(),
          label: 'name_of_reporter'.i18n(),
          itemAsString: (item) => item.name ?? '',
          onChanged: (value) => report.reporter = value,
          selectedItem: report.reporter,
          filterFn: (teamMember, filter) =>
              (teamMember.name != null && teamMember.name!.contains(filter)) ||
              (teamMember.teamMemberCd != null &&
                  teamMember.teamMemberCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
        AppTextField(
          label: 'affiliation_of_reporter'.i18n(),
          controller: TextEditingController(text: selectedReporterTeam?.name),
          enabled: false,
        ),
      ]);
    });
  }

  Widget _buildLine2(Report report) {
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTextField(
          label: 'position_of_reporter'.i18n(),
          controller: TextEditingController(
            text: report.reporter?.position,
          ),
          enabled: false,
        ),
        Container(),
      ]);
    });
  }
}
