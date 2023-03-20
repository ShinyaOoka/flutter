import 'dart:io';
import 'dart:math';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
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
    _report = args.report;

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
    await File('${tempDir.path}/demo.json')
        .writeAsString(await rootBundle.loadString("assets/example/demo.json"));
    final caseListItem = _zollSdkStore.caseListItems[device.serialNumber]
        ?.firstWhere((element) => element.caseId == caseId);
    final parsedCase = CaseParser.parse(
        await rootBundle.loadString("assets/example/demo.json"));
    _zollSdkStore.cases['caseId'] = parsedCase;
    parsedCase.events.removeWhere((element) => Random().nextBool());
    _zollSdkStore.cases['caseId2'] = parsedCase;
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
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      _buildConfirmButton(),
    ];
  }

  Widget _buildConfirmButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
          onPressed: () {
            _report.pulse = ObservableList.of(trendData.map((e) => e.hr));
            _report.bloodPressureLow =
                ObservableList.of(trendData.map((e) => e.nibpDia));
            _report.bloodPressureHigh =
                ObservableList.of(trendData.map((e) => e.nibpSys));
            _report.respiration =
                ObservableList.of(trendData.map((e) => e.resp));
            _report.spO2Percent =
                ObservableList.of(trendData.map((e) => e.spo2));

            _report.observationTime = ObservableList.of(trendData.map((e) =>
                e.time != null ? TimeOfDay.fromDateTime(e.time!) : null));
            Navigator.of(context).popUntil(
              (route) =>
                  ModalRoute.withName(Routes.createReport)(route) ||
                  ModalRoute.withName(Routes.editReport)(route),
            );
          },
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor),
          label: const Text('取得'),
          icon: Container(
            child: Icon(Icons.post_add),
            padding: EdgeInsets.only(right: 12),
          )),
    );
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
      final padding = isMobile ? 8.0 : 16.0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                EdgeInsets.only(top: padding, left: padding, right: padding),
            child: Column(
              children: [
                _buildCard(0),
                _buildCard(1),
                _buildCard(2),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
            height: isMobile ? 64 : 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('X Series イベント一覧',
                    style: Theme.of(context).textTheme.titleLarge),
                hasNewData
                    ? TextButton.icon(
                        onPressed: () {
                          setState(() {
                            myCase = _zollSdkStore.cases[caseId];
                            hasNewData = false;
                          });
                        },
                        label: Text("更新"),
                        icon: Icon(Icons.refresh))
                    : Container()
              ],
            ),
          ),
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
                      onTap: () {
                        if (activeIndex == null) return;
                        int? foundEventIndex;
                        for (var i = dataIndex; i > 0; i--) {
                          if (myCase!.events[i].type == 'TrendRpt') {
                            foundEventIndex = i;
                            break;
                          }
                        }

                        if (foundEventIndex == null) {
                          for (var i = dataIndex;
                              i < myCase!.events.length;
                              i++) {
                            if (myCase!.events[i].type == 'TrendRpt') {
                              foundEventIndex = i;
                              break;
                            }
                          }
                        }

                        if (foundEventIndex != null) {
                          setState(() {
                            final hrTrendData = myCase!.events[foundEventIndex!]
                                .rawData["Trend"]["Hr"]["TrendData"];
                            if (hrTrendData["DataStatus"] == 0) {
                              trendData[activeIndex!].hr =
                                  hrTrendData["Val"]["#text"];
                            } else {
                              trendData[activeIndex!].hr = null;
                            }
                            final nibpDiaTrendData = myCase!
                                .events[foundEventIndex]
                                .rawData["Trend"]["Nibp"]["Dia"]["TrendData"];
                            if (nibpDiaTrendData["DataStatus"] == 0) {
                              trendData[activeIndex!].nibpDia =
                                  nibpDiaTrendData["Val"]["#text"];
                            } else {
                              trendData[activeIndex!].nibpDia = null;
                            }
                            final nibpSysTrendData = myCase!
                                .events[foundEventIndex]
                                .rawData["Trend"]["Nibp"]["Sys"]["TrendData"];
                            if (nibpSysTrendData["DataStatus"] == 0) {
                              trendData[activeIndex!].nibpSys =
                                  nibpSysTrendData["Val"]["#text"];
                            } else {
                              trendData[activeIndex!].nibpSys = null;
                            }
                            final spo2TrendData = myCase!
                                .events[foundEventIndex]
                                .rawData["Trend"]["Spo2"]["TrendData"];
                            if (spo2TrendData["DataStatus"] == 0) {
                              trendData[activeIndex!].spo2 =
                                  spo2TrendData["Val"]["#text"];
                            } else {
                              trendData[activeIndex!].spo2 = null;
                            }
                            final respTrendData = myCase!
                                .events[foundEventIndex]
                                .rawData["Trend"]["Resp"]["TrendData"];
                            if (respTrendData["DataStatus"] == 0) {
                              trendData[activeIndex!].resp =
                                  respTrendData["Val"]["#text"];
                            } else {
                              trendData[activeIndex!].resp = null;
                            }
                            trendData[activeIndex!].time =
                                myCase!.events[foundEventIndex].date.toLocal();
                          });
                        }
                      });
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ),
        ],
      );
    });
  }

  _buildCard(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          activeIndex = index;
        });
      },
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 640;
        final textStyle = isMobile
            ? Theme.of(context).textTheme.labelSmall
            : Theme.of(context).textTheme.bodyMedium;
        final titleStyle = textStyle?.copyWith(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold);
        final labelStyle =
            textStyle?.copyWith(color: Theme.of(context).primaryColor);

        return Card(
          elevation: 0,
          color: activeIndex == index ? Color(0xFFF5F5F5) : null,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              side: BorderSide(
                  color: activeIndex == index
                      ? Theme.of(context).primaryColor
                      : Color(0xFFCCCCCC),
                  width: 2)),
          child: Column(children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(4),
              child: Row(children: [
                Expanded(
                  flex: 0,
                  child: Text(
                    "${index + 1}回目取得結果",
                    style: titleStyle,
                  ),
                ),
                const SizedBox(width: 16),
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
                        constraints: const BoxConstraints.tightFor(
                            width: 20, height: 20),
                      )
                    : Container()
              ]),
            ),
            Container(
              padding: EdgeInsets.all(isMobile ? 2 : 4),
              child: lineLayout(children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(isMobile ? 2 : 4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'HR: ', style: labelStyle),
                            TextSpan(
                                text:
                                    "${trendData[index].hr?.toString() ?? '--'}")
                          ],
                          style: textStyle,
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(isMobile ? 2 : 4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'BR: ', style: labelStyle),
                            TextSpan(
                                text:
                                    "${trendData[index].resp?.toString() ?? '--'}")
                          ],
                          style: textStyle,
                        ),
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(isMobile ? 2 : 4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'SPO2: ', style: labelStyle),
                            TextSpan(
                                text:
                                    "${trendData[index].spo2?.toString() ?? '--'}")
                          ],
                          style: textStyle,
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(isMobile ? 2 : 4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: '血圧: ', style: labelStyle),
                            TextSpan(
                                text:
                                    "${trendData[index].nibpDia?.toString() ?? '-'}/${(trendData[index].nibpSys?.toString() ?? '--')}")
                          ],
                          style: textStyle,
                        ),
                      ),
                    )),
                  ],
                )
              ]),
            )
          ]),
        );
      }),
    );
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
