import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/ui/data_viewer/twelve_lead_chart_screen/twelve_lead_chart_screen.dart';
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

class ListTwelveLeadScreenArguments {
  final String caseId;

  ListTwelveLeadScreenArguments({required this.caseId});
}

class ListTwelveLeadScreen extends StatefulWidget {
  const ListTwelveLeadScreen({super.key});

  @override
  _ListTwelveLeadScreenState createState() => _ListTwelveLeadScreenState();
}

class _ListTwelveLeadScreenState extends State<ListTwelveLeadScreen>
    with RouteAware, ReportSectionMixin {
  late ZollSdkStore _zollSdkStore;
  late String caseId;
  Case? myCase;
  bool hasNewData = false;
  late ScrollController _scrollController;

  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
    caseId = args.caseId;

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
      title: "12誘導表示",
      icon: Image.asset('assets/icons/C_12LeadSnapshot.png',
          width: 20, height: 20),
    );
  }

  Widget _buildBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNavigationRail(selectedIndex: 6, caseId: caseId),
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
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: myCase!.leads.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(
                AppConstants.dateTimeFormat.format(myCase!.leads[index].time)),
            onTap: () {
              Navigator.of(context).pushNamed(
                  DataViewerRoutes.dataViewerTwelveLeadChart,
                  arguments: TwelveLeadChartScreenArguments(
                      twelveLead: myCase!.leads[index],
                      myCase: myCase!,
                      caseId: caseId));
            }),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
