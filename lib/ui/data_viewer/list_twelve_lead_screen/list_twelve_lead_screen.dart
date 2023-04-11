import 'dart:io';
import 'dart:math';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/ui/data_viewer/twelve_lead_chart_screen/twelve_lead_chart_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:ak_azm_flutter/widgets/app_line_chart.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:ak_azm_flutter/widgets/zoomable_chart.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class ListTwelveLeadScreenArguments {
  final XSeriesDevice device;
  final String caseId;

  ListTwelveLeadScreenArguments({required this.device, required this.caseId});
}

class ListTwelveLeadScreen extends StatefulWidget {
  const ListTwelveLeadScreen({super.key});

  @override
  _ListTwelveLeadScreenState createState() => _ListTwelveLeadScreenState();
}

class _ListTwelveLeadScreenState extends State<ListTwelveLeadScreen>
    with RouteAware, ReportSectionMixin {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late XSeriesDevice device;
  late String caseId;
  Case? myCase;

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
    final args = ModalRoute.of(context)!.settings.arguments
        as ListTwelveLeadScreenArguments;
    device = args.device;
    caseId = args.caseId;

    _hostApi = context.read();
    _zollSdkStore = context.read();

    final tempDir = await getTemporaryDirectory();
    await File('${tempDir.path}/demo.json')
        .writeAsString(await rootBundle.loadString("assets/example/demo.json"));
    final caseListItem = _zollSdkStore.caseListItems[device.serialNumber]
        ?.firstWhere((element) => element.caseId == caseId);
    final parsedCase = CaseParser.parse(
        await rootBundle.loadString("assets/example/demo.json"));
    _zollSdkStore.cases['caseId'] = parsedCase;
    parsedCase.startTime = caseListItem?.startTime != null
        ? DateTime.parse(caseListItem!.startTime!).toLocal()
        : null;
    parsedCase.endTime = caseListItem?.endTime != null
        ? DateTime.parse(caseListItem!.endTime!).toLocal()
        : null;
    setState(() {
      myCase = _zollSdkStore.cases[caseId];
    });
    _hostApi.deviceDownloadCase(device, caseId, tempDir.path, null);
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
      title: "12Lead選択",
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
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        itemCount: myCase!.leads.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(
                AppConstants.dateTimeFormat.format(myCase!.leads[index].time)),
            onTap: () {
              Navigator.of(context).pushNamed(
                  DataViewerRoutes.dataViewerTwelveLeadChart,
                  arguments: TwelveLeadChartScreenArguments(
                      twelveLead: myCase!.leads[index]));
            }),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
