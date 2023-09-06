import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/app_date_picker.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
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
  final nameOfReporterController = TextEditingController();
  final affiliationOfReporterController = TextEditingController();
  final positionOfReporterController = TextEditingController();
  final approver1Controller = TextEditingController();
  final approver2Controller = TextEditingController();
  final approver3Controller = TextEditingController();

  late ReactionDisposer reactionDisposer;

  @override
  void initState() {
    super.initState();
    reportStore = context.read();
    reactionDisposer = autorun((_) {
    });
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
