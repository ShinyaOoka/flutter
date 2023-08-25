import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/models/case/case_event.dart';
import 'package:ak_azm_flutter/ui/data_viewer/expanded_cpr_chart_screen/expanded_cpr_chart_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/data_viewer/app_navigation_rail.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
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

class ListEventScreenArguments {
  final String caseId;

  ListEventScreenArguments({required this.caseId});
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
  late String caseId;
  late ScrollController scrollController;
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
    _routeObserver.unsubscribe(this);
  }

  @override
  Future<void> didPush() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as ListEventScreenArguments;
    caseId = args.caseId;

    _hostApi = context.read();
    _zollSdkStore = context.read();
    await _zollSdkStore.downloadCaseCompleter?.future;
    setState(() {
      myCase = _zollSdkStore.cases[caseId];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      leadingWidth: 88,
      title: "イベント",
      icon: Image.asset('assets/icons/C_Event.png', width: 20, height: 20),
    );
  }

  Widget _buildBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNavigationRail(selectedIndex: 3, caseId: caseId),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Stack(
            children: <Widget>[
              // _handleErrorMessage(),
              myCase != null
                  ? _buildMainContent()
                  : CustomProgressIndicatorWidget(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMainContent() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 640;
      return Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: ListView.separated(
          controller: scrollController,
          itemCount: myCase!.displayableEvents.length,
          itemBuilder: (context, itemIndex) {
            final dataIndex = myCase!.displayableEvents[itemIndex].item1;
            return ListTile(
                dense: isMobile,
                visualDensity:
                    isMobile ? VisualDensity.compact : VisualDensity.standard,
                title: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: AppConstants.dateTimeFormat
                          .format(myCase!.events[dataIndex].date),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).primaryColor)),
                  TextSpan(
                      text:
                          '  ${myCase!.events[dataIndex].type}${getJapaneseEventName(myCase!.events[dataIndex])}')
                ], style: Theme.of(context).textTheme.bodyMedium)),
                // '${myCase!.events[dataIndex].date} ${myCase!.events[dataIndex].date.isUtc}  ${myCase!.events[dataIndex]?.type}'),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      DataViewerRoutes.dataViewerExpandedEcgChart,
                      arguments: ExpandedCprChartScreenArguments(
                          caseId: caseId,
                          timestamp: myCase!
                              .events[dataIndex].date.microsecondsSinceEpoch));
                });
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
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
