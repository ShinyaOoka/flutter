import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/ui/list_device_screen/list_device_screen.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:ak_azm_flutter/widgets/report/report_form.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

class EditReportScreenArguments {
  final Report report;

  EditReportScreenArguments({required this.report});
}

class EditReportScreen extends StatefulWidget {
  const EditReportScreen({super.key});

  @override
  _EditReportScreenState createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> with RouteAware {
  late ReportStore _reportStore;
  late TeamStore _teamStore;
  late TeamMemberStore _teamMemberStore;
  late FireStationStore _fireStationStore;
  late ClassificationStore _classificationStore;
  late HospitalStore _hospitalStore;

  late ScrollController scrollController;

  late Report _report;

  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    final args =
        ModalRoute.of(context)!.settings.arguments as EditReportScreenArguments;
    _report = args.report;

    _reportStore = context.read();
    _teamStore = context.read();
    _fireStationStore = context.read();
    _teamMemberStore = context.read();
    _classificationStore = context.read();
    _hospitalStore = context.read();

    _teamStore.getTeams();
    _teamMemberStore.getAllTeamMembers();
    _fireStationStore.getAllFireStations();
    _classificationStore.getAllClassifications();

    _report.teamStore = _teamStore;
    _report.teamMemberStore = _teamMemberStore;
    _report.fireStationStore = _fireStationStore;
    _report.classificationStore = _classificationStore;

    if (!_hospitalStore.loading) {
      _hospitalStore.getHospitals();
    }
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
      title: Text('edit_report'.i18n()),
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
          switch (value) {
            case 0:
              Navigator.of(context).pushNamed(Routes.sendReport,
                  arguments: EditReportScreenArguments(report: _report));
              break;
            case 1:
              Navigator.of(context).pushNamed(Routes.sendReport,
                  arguments: SendReportScreenArguments(report: _report));
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
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _reportStore.loading
            ? const CustomProgressIndicatorWidget()
            : Material(child: _buildForm());
      },
    );
  }

  Widget _buildForm() {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(Routes.listDevice,
                      arguments: ListDeviceScreenArguments(report: _report));
                },
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(50))),
                child:
                    const Text('X Seriesデータ取得', style: TextStyle(fontSize: 20)),
              ),
            ),
            ReportForm(report: _report),
          ],
        ),
      ),
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_reportStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_reportStore.errorStore.errorMessage);
        }
        if (_fireStationStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_reportStore.errorStore.errorMessage);
        }
        if (_teamMemberStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_reportStore.errorStore.errorMessage);
        }
        if (_teamStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_reportStore.errorStore.errorMessage);
        }

        return const SizedBox.shrink();
      },
    );
  }

  _showErrorMessage(String message) {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: 'error_occurred'.i18n(),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    });

    return const SizedBox.shrink();
  }
}
