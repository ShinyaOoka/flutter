import 'dart:io';
import 'dart:math';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/ui/data_viewer/ecg_chart_screen/ecg_chart_screen.dart';
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

class ListEventScreenArguments {
  final XSeriesDevice device;
  final String caseId;

  ListEventScreenArguments({required this.device, required this.caseId});
}

class ListEventScreen extends StatefulWidget {
  const ListEventScreen({super.key});

  @override
  _ListEventScreenState createState() => _ListEventScreenState();
}

class _ListEventScreenState extends State<ListEventScreen>
    with RouteAware, ReportSectionMixin {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late XSeriesDevice device;
  late String caseId;
  late ScrollController scrollController;
  ReactionDisposer? reactionDisposer;
  Case? myCase;
  bool hasNewData = false;

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
    super.dispose();
    reactionDisposer?.call();
    _routeObserver.unsubscribe(this);
  }

  @override
  Future<void> didPush() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as ListEventScreenArguments;
    device = args.device;
    caseId = args.caseId;

    _hostApi = context.read();
    _zollSdkStore = context.read();
    setState(() {
      myCase = _zollSdkStore.cases[caseId];
    });
    reactionDisposer?.call();
    reactionDisposer = autorun((_) {
      final storeCase = _zollSdkStore.cases[caseId];
      if (storeCase != null && myCase == null) {
        setState(() {
          myCase = storeCase;
        });
      } else if (myCase != null && storeCase == null) {
        setState(() {
          hasNewData = false;
        });
      } else if (myCase != null && storeCase != null) {
        setState(() {
          if (myCase!.events.length != storeCase.events.length) {
            hasNewData = true;
          }
        });
      }
    });

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
      title: "イベント選択",
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
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 640;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    DataViewerRoutes.dataViewerEcgChart,
                    arguments: EcgChartScreenArguments(
                        device: device, caseId: caseId));
              },
              child: Text("ECG・バイタル表示")),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: ListView.separated(
                controller: scrollController,
                itemCount: myCase!.displayableEvents.length,
                itemBuilder: (context, itemIndex) {
                  final dataIndex = myCase!.displayableEvents[itemIndex].item1;
                  return ListTile(
                      dense: isMobile,
                      visualDensity: isMobile
                          ? VisualDensity.compact
                          : VisualDensity.standard,
                      title: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: AppConstants.dateTimeFormat
                                .format(myCase!.events[dataIndex].date),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Theme.of(context).primaryColor)),
                        TextSpan(
                            text:
                                '  ${myCase!.events[dataIndex].type}${getJapaneseEventName(myCase!.events[dataIndex])}')
                      ], style: Theme.of(context).textTheme.bodyMedium)),
                      // '${myCase!.events[dataIndex].date} ${myCase!.events[dataIndex].date.isUtc}  ${myCase!.events[dataIndex]?.type}'),
                      onTap: () {});
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ),
        ],
      );
    });
  }

  getJapaneseEventName(CaseEvent event) {
    if (event.type.i18n().compareTo(event.type) == 0) {
      return '';
    }
    String eventExtra = "";
    eventExtra = eventExtra += event.type == "TreatmentSnapshotEvt"
        ? event.rawData["TreatmentLbl"]
        : "";
    eventExtra = eventExtra +=
        event.type == "AlarmEvt" && event.rawData["Value"] == 1
            ? ": VF/VT"
            : "";
    return '／${event.type.i18n()}$eventExtra';
  }
}
