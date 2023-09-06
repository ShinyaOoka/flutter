import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:mobx/mobx.dart';

class RemarksSection extends StatefulWidget {
  final bool readOnly;

  const RemarksSection({super.key, this.readOnly = false});

  @override
  State<RemarksSection> createState() => _RemarksSectionState();
}

class _RemarksSectionState extends State<RemarksSection>
    with ReportSectionMixin {
  final summaryOfOccurrenceController = TextEditingController();
  final summaryOfOccurrenceScrollController = ScrollController();
  final remarksController = TextEditingController();
  final remarksScrollController = ScrollController();
  late ReactionDisposer reactionDisposer;
  late ReportStore reportStore;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
    });
  }

  @override
  void dispose() {
    reactionDisposer();
    summaryOfOccurrenceController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        ],
      );
    });
  }

}
