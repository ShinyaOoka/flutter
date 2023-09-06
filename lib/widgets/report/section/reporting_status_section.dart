import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class ReportingStatusSection extends StatefulWidget {
  final bool readOnly;

  const ReportingStatusSection({super.key, this.readOnly = false});

  @override
  State<ReportingStatusSection> createState() => _ReportingStatusSectionState();
}

class _ReportingStatusSectionState extends State<ReportingStatusSection>
    with ReportSectionMixin {
  final perceiverNameController = TextEditingController();
  final callerNameController = TextEditingController();
  final callerTelController = TextEditingController();
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
    perceiverNameController.dispose();
    callerNameController.dispose();
    callerTelController.dispose();
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
