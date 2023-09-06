import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/models/team/team.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
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
  final teamCaptainNameController = TextEditingController();
  final teamMemberNameController = TextEditingController();
  final institutionalMemberNameController = TextEditingController();

  late ReportStore reportStore;
  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
      syncControllerValue(teamCaptainNameController,
          reportStore.selectingReport!.teamCaptainName);
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
        ],
      );
    });
  }

  Widget _buildLine1(Report report, BuildContext context) {
    final teamStore = Provider.of<TeamStore>(context);
    return Observer(builder: (context) {
      return lineLayout(children: [
        AppTextField(
          controller: teamCaptainNameController,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          label: 'team_captain_name'.i18n(),
          onChanged: (value) => report.teamCaptainName = value,
          maxLength: 20,
          readOnly: widget.readOnly,
          keyboardType: TextInputType.multiline,
        ),
      ]);
    });
  }

}
