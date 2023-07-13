import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/ui/data_viewer/ecg_chart_screen/ecg_chart_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/app_text_field.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class InfoScreenArguments {
  final String caseId;

  InfoScreenArguments({required this.caseId});
}

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen>
    with RouteAware, ReportSectionMixin {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
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
        ModalRoute.of(context)!.settings.arguments as InfoScreenArguments;
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
    await _loadTestData();
    _hostApi.deviceDownloadCase(
        _zollSdkStore.selectedDevice!, caseId, tempDir.path, null);
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

  Future<void> _loadTestData() async {
    final tempDir = await getTemporaryDirectory();
    await File('${tempDir.path}/$caseId.json').writeAsString(
        await rootBundle.loadString("assets/example/$caseId.json"));
    final caseListItem = _zollSdkStore
        .caseListItems[_zollSdkStore.selectedDevice?.serialNumber]
        ?.firstWhere((element) => element.caseId == caseId);
    final parsedCase = CaseParser.parse(
        await rootBundle.loadString("assets/example/$caseId.json"));
    _zollSdkStore.cases[caseId] = parsedCase;
    parsedCase.startTime = caseListItem?.startTime != null
        ? DateTime.parse(caseListItem!.startTime!).toLocal()
        : null;
    parsedCase.endTime = caseListItem?.endTime != null
        ? DateTime.parse(caseListItem!.endTime!).toLocal()
        : null;
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: _buildBackButton(),
      leadingWidth: 88,
      title: "一般",
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
    final serial = myCase!.caseSummary.rawData['SerialNumber'];
    final version = myCase!.caseSummary.rawData['SwVer'];
    final deviceOn = myCase!.events
        .firstWhere((e) => e.type == 'AnnotationEvt System On')
        .rawData['StdHdr']['DevDateTime']
        .toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              AppTextField(
                label: '実施回数',
                readOnly: true,
                controller: TextEditingController(
                    text: myCase!.caseSummary.rawData['PatientData']
                        ['PatientId']),
              ),
              AppTextField(
                label: '開始時刻',
                readOnly: true,
                controller: TextEditingController(
                    text: myCase!.caseSummary.rawData['StartTime']),
              ),
              AppTextField(
                label: 'データの期間',
                readOnly: true,
                controller: TextEditingController(
                    text: _printDuration(
                        myCase!.endTime!.difference(myCase!.startTime!))),
              ),
              AppTextField(
                label: 'デバイスの種類',
                readOnly: true,
                controller: TextEditingController(text: ''),
              ),
              AppTextField(
                label: 'デバイスID',
                readOnly: true,
                controller: TextEditingController(text: '$serial($version)'),
              ),
              AppTextField(
                label: '電源オン時刻',
                readOnly: true,
                controller: TextEditingController(text: deviceOn),
              ),
              AppTextField(
                label: '電源オン調整時刻',
                readOnly: true,
                controller: TextEditingController(text: deviceOn),
              ),
              AppTextField(
                label: '患者ID /MR番号',
                readOnly: true,
                controller: TextEditingController(
                    text: myCase!.caseSummary.rawData['PatientData']
                        ['PatientId']),
              ),
              AppTextField(
                label: '氏',
                readOnly: true,
                controller: TextEditingController(
                    text: myCase!.caseSummary.rawData['PatientData']
                        ['FirstName']),
              ),
              AppTextField(
                label: '名',
                readOnly: true,
                controller: TextEditingController(
                    text: myCase!.caseSummary.rawData['PatientData']
                        ['LastName']),
              ),
              AppTextField(
                label: '性別',
                readOnly: true,
                controller: TextEditingController(
                    text: myCase!.caseSummary.rawData['PatientData']['Sex']),
              ),
              AppTextField(
                label: '人種',
                readOnly: true,
                controller: TextEditingController(
                    text: myCase!.caseSummary.rawData['PatientData']
                        ['PatientMode']),
              ),
              AppTextField(
                label: '生年月日',
                readOnly: true,
                controller: TextEditingController(text: ''),
              ),
              AppTextField(
                label: '身長',
                readOnly: true,
                // controller: TextEditingController(
                //     text: myCase!.caseSummary
                //             .rawData['PatientData']['Height']['#text']
                //             .toString() +
                //         myCase!.caseSummary.rawData['PatientData']['Height']
                //             ['@Units']),
                controller: TextEditingController(text: ""),
              ),
              AppTextField(
                label: '体重',
                readOnly: true,
                // controller: TextEditingController(
                //     text: myCase!.caseSummary
                //             .rawData['PatientData']['Weight']['#text']
                //             .toString() +
                //         myCase!.caseSummary.rawData['PatientData']['Weight']
                //             ['@Units']),
                controller: TextEditingController(text: ""),
              ),
            ],
          ),
        ),
      ),
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

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
