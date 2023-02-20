import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/models/team/team.dart';
import 'package:ak_azm_flutter/models/team_member/team_member.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/stores/team_member/team_member_store.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class TeamInfoSection extends StatefulWidget {
  final bool readOnly;

  const TeamInfoSection({super.key, this.readOnly = false});

  @override
  State<TeamInfoSection> createState() => _TeamInfoSectionState();
}

class _TeamInfoSectionState extends State<TeamInfoSection>
    with ReportSectionMixin {
  final totalController = TextEditingController();
  final teamController = TextEditingController();

  late ReportStore reportStore;
  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(
          totalController, reportStore.selectingReport!.totalCount);
      syncControllerValue(
          teamController, reportStore.selectingReport!.teamCount);
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    totalController.dispose();
    teamController.dispose();
    super.dispose();
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
          _buildLine5(reportStore.selectingReport!, context)
        ],
      );
    });
  }

  Widget _buildLine1(Report report, BuildContext context) {
    final teamStore = Provider.of<TeamStore>(context);
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppDropdown<Team>(
          showSearchBox: true,
          items: teamStore.teams.values.toList(),
          label: 'team_name'.i18n(),
          itemAsString: ((item) => item.name ?? ''),
          onChanged: (value) {
            if (value?.teamCd == report.teamCd) return;
            report.team = value;
            report.teamCaptain = null;
            report.teamMember = null;
            report.institutionalMember = null;
          },
          selectedItem: report.team,
          filterFn: (team, filter) =>
              (team.name != null && team.name!.contains(filter)) ||
              (team.teamCd != null && team.teamCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
        AppTextField(
          label: 'team_tel'.i18n(),
          controller: TextEditingController(
            text: report.team?.tel,
          ),
          enabled: false,
        )
      ]);
    });
  }

  Widget _buildLine2(Report report, BuildContext context) {
    final teamMemberStore = Provider.of<TeamMemberStore>(context);
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTextField(
          label: 'fire_station_name'.i18n(),
          controller: TextEditingController(text: report.fireStation?.name),
          enabled: false,
        ),
        AppDropdown<TeamMember>(
          showSearchBox: true,
          items: teamMemberStore.teamMembers.values
              .where((element) => element.teamCd == report.teamCd)
              .toList(),
          label: 'team_captain_name'.i18n(),
          itemAsString: ((item) => item.name ?? ''),
          onChanged: (value) => report.teamCaptain = value,
          selectedItem: report.teamCaptain,
          filterFn: (teamMember, filter) =>
              (teamMember.name != null && teamMember.name!.contains(filter)) ||
              (teamMember.teamMemberCd != null &&
                  teamMember.teamMemberCd!.contains(filter)),
          readOnly: widget.readOnly,
        ),
      ]);
    });
  }

  Widget _buildLine3(Report report, BuildContext context) {
    return Observer(builder: (context) {
      bool? withLifesaver;
      if (report.teamCaptain?.lifesaverQualification != null) {
        withLifesaver = (withLifesaver != null && withLifesaver) ||
            report.teamCaptain!.lifesaverQualification!;
      }
      if (report.teamMember?.lifesaverQualification != null) {
        withLifesaver = (withLifesaver != null && withLifesaver) ||
            report.teamMember!.lifesaverQualification!;
      }
      if (report.institutionalMember?.lifesaverQualification != null) {
        withLifesaver = (withLifesaver != null && withLifesaver) ||
            report.institutionalMember!.lifesaverQualification!;
      }
      return lineLayout(children: [
        AppTextField(
          label: 'lifesaver_qualification'.i18n(),
          controller: TextEditingController(
              text: formatBool(report.teamCaptain?.lifesaverQualification)),
          enabled: false,
        ),
        AppTextField(
          label: 'with_lifesavers'.i18n(),
          controller: TextEditingController(text: formatBool(withLifesaver)),
          enabled: false,
        ),
      ]);
    });
  }

  Widget _buildLine4(Report report, BuildContext context) {
    return Observer(builder: (context) {
      final teamMemberStore = Provider.of<TeamMemberStore>(context);
      return lineLayout(children: [
        optional(
          child: AppDropdown<TeamMember>(
            showSearchBox: true,
            items: teamMemberStore.teamMembers.values
                .where((element) => element.teamCd == report.teamCd)
                .toList(),
            label: 'team_member_name'.i18n(),
            itemAsString: ((item) => item.name ?? ''),
            onChanged: (value) => report.teamMember = value,
            selectedItem: report.teamMember,
            filterFn: (teamMember, filter) =>
                (teamMember.name != null &&
                    teamMember.name!.contains(filter)) ||
                (teamMember.teamMemberCd != null &&
                    teamMember.teamMemberCd!.contains(filter)),
            readOnly: widget.readOnly,
          ),
          context: context,
        ),
        optional(
          child: AppDropdown<TeamMember>(
            showSearchBox: true,
            items: teamMemberStore.teamMembers.values
                .where((element) => element.teamCd == report.teamCd)
                .toList(),
            label: 'institutional_member_name'.i18n(),
            itemAsString: ((item) => item.name ?? ''),
            onChanged: (value) {
              report.institutionalMember = value;
            },
            selectedItem: report.institutionalMember,
            filterFn: (teamMember, filter) =>
                (teamMember.name != null &&
                    teamMember.name!.contains(filter)) ||
                (teamMember.teamMemberCd != null &&
                    teamMember.teamMemberCd!.contains(filter)),
            readOnly: widget.readOnly,
          ),
          context: context,
        ),
      ]);
    });
  }

  Widget _buildLine5(Report report, BuildContext context) {
    return lineLayout(children: [
      optional(
        child: AppTextField(
          controller: totalController,
          label: 'total'.i18n(),
          keyboardType: TextInputType.number,
          onChanged: (item) => report.totalCount = int.parse(item),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 6,
          readOnly: widget.readOnly,
        ),
        context: context,
      ),
      optional(
        child: AppTextField(
          controller: teamController,
          label: 'team'.i18n(),
          keyboardType: TextInputType.number,
          onChanged: (item) => report.teamCount = int.parse(item),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 6,
          readOnly: widget.readOnly,
        ),
        context: context,
      ),
    ]);
  }
}
