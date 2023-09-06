import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
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
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';

class TreatmentSection extends StatefulWidget {
  final bool readOnly;

  const TreatmentSection({super.key, this.readOnly = false});

  @override
  State<TreatmentSection> createState() => _TreatmentSectionState();
}

class _TreatmentSectionState extends State<TreatmentSection>
    with ReportSectionMixin {
  String? editingO2Administration;
  final o2AdministrationController = TextEditingController();
  final bsMeasurement1Controller = TextEditingController();
  final punctureSite1Controller = TextEditingController();
  final bsMeasurement2Controller = TextEditingController();
  final punctureSite2Controller = TextEditingController();
  final otherController = TextEditingController();
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
    o2AdministrationController.dispose();
    bsMeasurement1Controller.dispose();
    punctureSite1Controller.dispose();
    bsMeasurement2Controller.dispose();
    punctureSite2Controller.dispose();
    otherController.dispose();
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
