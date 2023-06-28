import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/ui/data_viewer/expanded_cpr_chart_screen/expanded_cpr_chart_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/app_checkbox.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class EcgChartScreenArguments {
  final String caseId;
  final int timestamp;

  EcgChartScreenArguments({required this.caseId, required this.timestamp});
}

class EcgChartScreen extends StatefulWidget {
  const EcgChartScreen({super.key});

  @override
  _EcgChartScreenState createState() => _EcgChartScreenState();
}

class _EcgChartScreenState extends State<EcgChartScreen>
    with RouteAware, ReportSectionMixin {
  late ZollSdkStore _zollSdkStore;
  late String caseId;
  late int timestamp;
  String chartType = 'Pads';
  Case? myCase;
  bool expandOnTap = false;

  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    _routeObserver.unsubscribe(this);
  }

  @override
  Future<void> didPush() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as EcgChartScreenArguments;
    caseId = args.caseId;
    timestamp = args.timestamp;

    _zollSdkStore = context.read();
    setState(() {
      myCase = _zollSdkStore.cases[caseId];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: _buildBackButton(),
      leadingWidth: 88,
      title: "ECG・バイタル表示",
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const SizedBox(
        width: 12,
        child: Icon(Icons.arrow_back_ios),
      ),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('back'.i18n()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        // _handleErrorMessage(),
        myCase != null
            ? _buildMainContent()
            : const CustomProgressIndicatorWidget(),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCheckbox(
                label: 'クリックしたら拡大ECGへ移動',
                value: expandOnTap,
                onChanged: (x) => setState(() => expandOnTap = x ?? false)),
            DropdownButton<String>(
                value: chartType,
                items: myCase!.waves.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (x) {
                  setState(() {
                    chartType = x!;
                  });
                }),
            EcgChart(
              samples: myCase!.waves[chartType]!.samples,
              cprCompressions: myCase!.cprCompressions,
              initTimestamp: timestamp,
              segments: 4,
              initDuration: Duration(minutes: 1),
              onTap: (timestamp) {
                if (expandOnTap) {
                  Navigator.of(context).pushNamed(
                      DataViewerRoutes.dataViewerExpandedEcgChart,
                      arguments: ExpandedCprChartScreenArguments(
                          caseId: caseId, timestamp: timestamp));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
