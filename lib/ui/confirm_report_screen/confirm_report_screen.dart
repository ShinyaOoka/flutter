import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/ui/edit_report_screen/edit_report_screen.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:ak_azm_flutter/widgets/report/report_form.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart' as MobX;
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

class _ConfirmReportScreenState extends State<ConfirmReportScreen>
    with RouteAware {
  late ReportStore _reportStore;
  late TeamStore _teamStore;
  late TeamMemberStore _teamMemberStore;
  late FireStationStore _fireStationStore;
  late ClassificationStore _classificationStore;
  late HospitalStore _hospitalStore;

  late ScrollController scrollController;

  late MobX.Observable<Report> _report;

  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

  late MobX.Action setReportAction;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    setReportAction = MobX.Action((Report report) {
      _report.value = report;
    });
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
    final args = ModalRoute.of(context)!.settings.arguments
        as ConfirmReportScreenArguments;
    print('Pushed');
    _report = MobX.Observable(args.report);

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

    _report.value.teamStore = _teamStore;
    _report.value.teamMemberStore = _teamMemberStore;
    _report.value.fireStationStore = _fireStationStore;
    _report.value.classificationStore = _classificationStore;

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
        onSelected: (value) async {
          switch (value) {
            case 0:
              var result = await Navigator.of(context).pushNamed(
                  Routes.editReport,
                  arguments: EditReportScreenArguments(report: _report.value));
              if (result != null) {
                setReportAction([result]);
              }
              break;
            case 1:
              Navigator.of(context).pushNamed(Routes.sendReport,
                  arguments: SendReportScreenArguments(report: _report.value));
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
        child: Observer(
          builder: (context) => ReportForm(
            report: _report.value,
            readOnly: false,
            radio: false,
            expanded: true,
          ),
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
