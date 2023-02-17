import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  final Report report;

  ListEventScreenArguments(
      {required this.device, required this.caseId, required this.report});
}

class ListEventScreen extends StatefulWidget {
  const ListEventScreen({super.key});

  @override
  _ListEventScreenState createState() => _ListEventScreenState();
}

class EditingVitalSign {
  int? hr;
  int? resp;
  int? spo2;
  int? nibpSys;
  int? nibpDia;
  DateTime? time;

  EditingVitalSign(
      {this.hr, this.resp, this.spo2, this.nibpSys, this.nibpDia, this.time});
}

class _ListEventScreenState extends State<ListEventScreen>
    with RouteAware, ReportSectionMixin {
  late Report _report;
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late XSeriesDevice device;
  late String caseId;
  late ScrollController scrollController;
  int? activeIndex;
  List<EditingVitalSign> trendData = [
    EditingVitalSign(),
    EditingVitalSign(),
    EditingVitalSign()
  ];

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
    _routeObserver.unsubscribe(this);
  }

  @override
  Future<void> didPush() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as ListEventScreenArguments;
    device = args.device;
    caseId = args.caseId;
    _report = args.report;

    _hostApi = context.read();
    _zollSdkStore = context.read();
    final now = DateTime.now();
    setState(() {
      trendData = [
        EditingVitalSign(
          hr: _report.pulse?[0],
          nibpDia: _report.bloodPressureLow?[0],
          nibpSys: _report.bloodPressureHigh?[0],
          resp: _report.respiration?[0],
          spo2: _report.spO2Percent?[0],
          time: _report.observationTime?[0] != null
              ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  _report.observationTime![0]!.hour,
                  _report.observationTime![0]!.minute)
              : null,
        ),
        EditingVitalSign(
          hr: _report.pulse?[1],
          nibpDia: _report.bloodPressureLow?[1],
          nibpSys: _report.bloodPressureHigh?[1],
          resp: _report.respiration?[1],
          spo2: _report.spO2Percent?[1],
          time: _report.observationTime?[1] != null
              ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  _report.observationTime![1]!.hour,
                  _report.observationTime![1]!.minute)
              : null,
        ),
        EditingVitalSign(
          hr: _report.pulse?[2],
          nibpDia: _report.bloodPressureLow?[2],
          nibpSys: _report.bloodPressureHigh?[2],
          resp: _report.respiration?[2],
          spo2: _report.spO2Percent?[2],
          time: _report.observationTime?[2] != null
              ? DateTime(
                  now.year,
                  now.month,
                  now.day,
                  _report.observationTime![2]!.hour,
                  _report.observationTime![2]!.minute)
              : null,
        ),
      ];
    });

    final tempDir = await getTemporaryDirectory();
    // await File(tempDir.path + '/demo.json')
    //     .writeAsString(await rootBundle.loadString("assets/example/demo.json"));
    // final caseListItem = _zollSdkStore.caseListItems[device.serialNumber]
    //     ?.firstWhere((element) => element.caseId == caseId);
    // final parsedCase = CaseParser.parse(
    //     await rootBundle.loadString("assets/example/demo.json"));
    // _zollSdkStore.cases['caseId'] = parsedCase;
    // _zollSdkStore.cases['caseId2'] = parsedCase;
    // parsedCase.startTime = caseListItem?.startTime != null
    //     ? DateTime.parse(caseListItem!.startTime!).toLocal()
    //     : null;
    // parsedCase.endTime = caseListItem?.endTime != null
    //     ? DateTime.parse(caseListItem!.endTime!).toLocal()
    //     : null;
    _hostApi.deviceDownloadCase(device, caseId, tempDir.path, null);
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
      title: Text('get_xseries_data'.i18n()),
      actions: _buildActions(),
      centerTitle: true,
      leading: _buildBackButton(),
      leadingWidth: 100,
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      _buildConfirmButton(),
    ];
  }

  Widget _buildConfirmButton() {
    return TextButton(
      onPressed: () {
        _report.pulse = ObservableList.of(trendData.map((e) => e.hr));
        _report.bloodPressureLow =
            ObservableList.of(trendData.map((e) => e.nibpDia));
        _report.bloodPressureHigh =
            ObservableList.of(trendData.map((e) => e.nibpSys));
        _report.respiration = ObservableList.of(trendData.map((e) => e.resp));
        _report.spO2Percent = ObservableList.of(trendData.map((e) => e.spo2));

        _report.observationTime = ObservableList.of(trendData.map(
            (e) => e.time != null ? TimeOfDay.fromDateTime(e.time!) : null));
        Navigator.of(context).popUntil(
          (route) =>
              ModalRoute.withName(Routes.createReport)(route) ||
              ModalRoute.withName(Routes.editReport)(route),
        );
      },
      style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor),
      child: const Text('取得'),
    );
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
        // _handleErrorMessage(),
        Observer(
            builder: (context) => _zollSdkStore.cases[caseId] != null
                ? _buildMainContent()
                : const CustomProgressIndicatorWidget()),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text("please_choose_case".i18n(),
              style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: Observer(
            builder: (context) {
              final caseData = _zollSdkStore.cases[caseId]!;
              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: LayoutBuilder(builder: (context, constraints) {
                  return ListView.separated(
                    controller: scrollController,
                    itemCount: caseData.displayableEvents.length,
                    itemBuilder: (context, itemIndex) {
                      final dataIndex =
                          caseData.displayableEvents[itemIndex].item1;
                      return ListTile(
                          dense: constraints.maxWidth < 640,
                          visualDensity: constraints.maxWidth < 640
                              ? VisualDensity.compact
                              : VisualDensity.standard,
                          title: Text(
                              '${AppConstants.dateTimeFormat.format(caseData.events[dataIndex].date)}   ${caseData.events[dataIndex].type.i18n()}${caseData.events[dataIndex].type == "TreatmentSnapshotEvt" ? caseData.events[dataIndex].rawData["TreatmentLbl"] : ""}'),
                          // '${caseData.events[dataIndex].date} ${caseData.events[dataIndex].date.isUtc}  ${caseData.events[dataIndex]?.type}'),
                          onTap: () {
                            if (activeIndex == null) return;
                            int? foundEventIndex;
                            for (var i = dataIndex; i > 0; i--) {
                              if (caseData.events[i].type == 'TrendRpt') {
                                foundEventIndex = i;
                                break;
                              }
                            }

                            if (foundEventIndex == null) {
                              for (var i = dataIndex;
                                  i < caseData.events.length;
                                  i++) {
                                if (caseData.events[i].type == 'TrendRpt') {
                                  foundEventIndex = i;
                                  break;
                                }
                              }
                            }

                            if (foundEventIndex != null) {
                              setState(() {
                                trendData[activeIndex!].hr = caseData
                                        .events[foundEventIndex!]
                                        .rawData["Trend"]["Hr"]["TrendData"]
                                    ["Val"]["#text"];
                                trendData[activeIndex!].nibpDia = caseData
                                        .events[foundEventIndex]
                                        .rawData["Trend"]["Nibp"]["Dia"]
                                    ["TrendData"]["Val"]["#text"];
                                trendData[activeIndex!].nibpSys = caseData
                                        .events[foundEventIndex]
                                        .rawData["Trend"]["Nibp"]["Sys"]
                                    ["TrendData"]["Val"]["#text"];
                                trendData[activeIndex!].spo2 = caseData
                                        .events[foundEventIndex]
                                        .rawData["Trend"]["Spo2"]["TrendData"]
                                    ["Val"]["#text"];
                                trendData[activeIndex!].resp = caseData
                                        .events[foundEventIndex]
                                        .rawData["Trend"]["Resp"]["TrendData"]
                                    ["Val"]["#text"];
                                trendData[activeIndex!].time = caseData
                                    .events[foundEventIndex].date
                                    .toLocal();
                              });
                            }
                          });
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  );
                }),
              );
            },
          ),
        ),
        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 640;
          return Container(
            padding: EdgeInsets.all(isMobile ? 8 : 16),
            child: Column(
              children: [
                _buildCard(0),
                SizedBox(height: isMobile ? 4 : 16),
                _buildCard(1),
                SizedBox(height: isMobile ? 4 : 16),
                _buildCard(2),
              ],
            ),
          );
        })
      ],
    );
  }

  _buildCard(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          activeIndex = index;
        });
      },
      child: Card(
        color:
            activeIndex == index ? Theme.of(context).primaryColorLight : null,
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(4),
            child: Row(children: [
              Expanded(child: Text("${index + 1}回目取得結果")),
              trendData[index].time != null
                  ? Expanded(
                      child: Text(AppConstants.timeFormat
                          .format(trendData[index].time!)))
                  : Container(),
              trendData[index].time != null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          trendData[index] = EditingVitalSign();
                        });
                      },
                      icon: const Icon(Icons.close, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints.tightFor(width: 20, height: 20),
                    )
                  : Container()
            ]),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            child: lineLayout(children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Text("HR: ${trendData[index].hr?.toString() ?? ''}"),
                  )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(4),
                    child:
                        Text("BR: ${trendData[index].resp?.toString() ?? ''}"),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                        "SPO2: ${trendData[index].spo2?.toString() ?? ''}"),
                  )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                        "血圧: ${trendData[index].nibpDia != null || trendData[index].nibpSys != null ? "${trendData[index].nibpDia?.toString() ?? ''}/${(trendData[index].nibpSys?.toString() ?? '')}" : ""}"),
                  )),
                ],
              )
            ]),
          )
        ]),
      ),
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
