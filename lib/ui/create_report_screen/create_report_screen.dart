import 'package:ak_azm_flutter/ui/list_device_screen/list_device_screen.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/fire_station/fire_station_store.dart';
import 'package:ak_azm_flutter/stores/hospital/hospital_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';
import 'package:ak_azm_flutter/widgets/report/report_form.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  _CreateReportScreenState createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen>
    with RouteAware {
  late ReportStore _reportStore;
  late TeamStore _teamStore;
  late FireStationStore _fireStationStore;
  late ClassificationStore _classificationStore;
  late HospitalStore _hospitalStore;

  late ScrollController scrollController;

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
    _reportStore = Provider.of<ReportStore>(context);
    _teamStore = Provider.of<TeamStore>(context);
    _fireStationStore = Provider.of<FireStationStore>(context);
    _classificationStore = Provider.of<ClassificationStore>(context);
    _hospitalStore = Provider.of<HospitalStore>(context);

    _teamStore.getTeams();
    _fireStationStore.getAllFireStations();
    _classificationStore.getAllClassifications();
    _hospitalStore.getHospitals();

    final report = Report();

    report.teamStore = _teamStore;
    report.fireStationStore = _fireStationStore;
    report.classificationStore = _classificationStore;
    report.hospitalStore = _hospitalStore;

    _reportStore.setSelectingReport(report);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildGetDataFromXSeriesButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'create_report'.i18n(),
      actions: _buildActions(),
      leading: _buildBackButton(),
      leadingWidth: 88,
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      _buildCreateReportButton(),
    ];
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: Container(
        width: 12,
        child: const Icon(Icons.arrow_back_ios),
      ),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('back'.i18n()),
      onPressed: () async {
        final result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("未登録終了確認"),
                  content: Text("入力内容を保存せずに戻ります。よろしいですか？"),
                  actions: [
                    TextButton(
                      child: Text("はい"),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                    TextButton(
                      child: Text("キャンセル"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ],
                ));
        if (result != true) return;
        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildCreateReportButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        icon: const Icon(Icons.save),
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            foregroundColor: Theme.of(context).primaryColor),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          final result = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("登録前確認"),
                    content: Text("入力内容を登録しますか？"),
                    actions: [
                      TextButton(
                        child: Text("はい"),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                      TextButton(
                        child: Text("キャンセル"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ],
                  ));
          if (result != true) return;
          await _reportStore.createReport(_reportStore.selectingReport!);
          await _reportStore.getReports();
          if (!mounted) return;
          Navigator.of(context).pop();
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            FlushbarHelper.createInformation(
              message: '登録処理を完了しました。',
              duration: const Duration(seconds: 3),
            ).show(context);
          });
        },
        label: Text('create'.i18n()),
      ),
    );
  }

  Widget _buildGetDataFromXSeriesButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).pushNamed(Routes.listDevice,
            arguments: ListDeviceScreenArguments(
                report: _reportStore.selectingReport!));
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.data_thresholding_outlined),
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
        child: const ReportForm(),
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
