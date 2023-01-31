import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/fire_station/fire_station_store.dart';
import 'package:ak_azm_flutter/stores/hospital/hospital_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/stores/team_member/team_member_store.dart';
import 'package:ak_azm_flutter/ui/send_report_screen/send_report_screen.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:localization/localization.dart';

class ConfirmReportScreenArguments {
  final Report report;

  ConfirmReportScreenArguments({required this.report});
}

class ConfirmReportScreen extends StatefulWidget {
  const ConfirmReportScreen({super.key});

  @override
  _ConfirmReportScreenState createState() => _ConfirmReportScreenState();
}

class _ConfirmReportScreenState extends State<ConfirmReportScreen> {
  late TeamStore _teamStore;
  late TeamMemberStore _teamMemberStore;
  late FireStationStore _fireStationStore;
  late ClassificationStore _classificationStore;
  late HospitalStore _hospitalStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _teamStore = Provider.of<TeamStore>(context);
    _fireStationStore = Provider.of<FireStationStore>(context);
    _teamMemberStore = Provider.of<TeamMemberStore>(context);
    _classificationStore = Provider.of<ClassificationStore>(context);
    _hospitalStore = Provider.of<HospitalStore>(context);

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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('confirm_report'.i18n()),
      actions: _buildActions(),
      centerTitle: true,
      leading: _buildBackButton(),
      leadingWidth: 100,
    );
  }

  List<Widget> _buildActions() {
    return [
      PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(value: 0, child: Text('edit'.i18n())),
            PopupMenuItem(value: 1, child: Text('print_pdf'.i18n()))
          ];
        },
        onSelected: (value) {
          final args = ModalRoute.of(context)!.settings.arguments
              as ConfirmReportScreenArguments;
          switch (value) {
            case 1:
              Navigator.of(context).pushNamed(Routes.sendReport,
                  arguments: SendReportScreenArguments(report: args.report));
              break;
          }
        },
      )
    ];
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const Icon(Icons.arrow_back),
      style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor),
      label: Text('back'.i18n()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return Container();
  }
}
