import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/hospital/hospital.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/app_dropdown.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/app_time_picker.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

class TransportInfoSection extends StatefulWidget {
  final bool readOnly;

  const TransportInfoSection({super.key, this.readOnly = false});

  @override
  State<TransportInfoSection> createState() => _TransportInfoSectionState();
}

class _TransportInfoSectionState extends State<TransportInfoSection>
    with ReportSectionMixin {
  final otherReasonForTransferController = TextEditingController();
  final otherReasonForNotTransferringController = TextEditingController();
  final otherMedicalTransportFacilityController = TextEditingController();
  final otherTransferringMedicalInstitutionController = TextEditingController();

  final otherReasonForNotTransferringScrollController = ScrollController();

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
    otherReasonForTransferController.dispose();
    otherReasonForNotTransferringController.dispose();
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
