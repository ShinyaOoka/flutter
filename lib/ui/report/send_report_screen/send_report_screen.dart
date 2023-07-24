import 'package:ak_azm_flutter/data/local/constants/report_type.dart';
import 'package:ak_azm_flutter/ui/report/preview_report_screen/preview_report_screen.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:localization/localization.dart';

class SendReportScreen extends StatefulWidget {
  const SendReportScreen({super.key});

  @override
  _SendReportScreenState createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if (!_teamStore.loading) {
    //   _teamStore.getTeams();
    // }

    // if (!_fireStationStore.loading) {
    //   _fireStationStore.getFireStations();
    // }

    // if (!_teamMemberStore.loading) {
    //   _teamMemberStore.getTeamMembers();
    // }

    // if (!_classificationStore.loading) {
    //   _classificationStore.getClassifications();
    // }

    // if (!_hospitalStore.loading) {
    //   _hospitalStore.getHospitals();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      leadings: [_buildBackButton()],
      leadingWidth: 88,
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const SizedBox(
        width: 12,
        child: Icon(Icons.arrow_back_ios),
      ),
      style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor),
      label: Text('back'.i18n()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ReportRoutes.reportPreviewReport,
                arguments: PreviewReportScreenArguments(
                    reportType: ReportType.certificate));
          },
          style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(const Size.fromHeight(50))),
          child: const Text('傷病者輸送証', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ReportRoutes.reportPreviewReport,
                arguments: PreviewReportScreenArguments(
                    reportType: ReportType.ambulance));
          },
          style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(const Size.fromHeight(50))),
          child: const Text('救急業務実施報告書', style: TextStyle(fontSize: 20)),
        )
      ]),
    );
  }
}
