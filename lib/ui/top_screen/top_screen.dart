import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/report_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({super.key});

  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> with RouteAware {
  late ReportStore _reportStore;
  late TeamStore _teamStore;
  late ZollSdkStore _zollSdkStore;
  late ClassificationStore _classificationStore;
  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();
  bool initialized = false;

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
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _reportStore = context.read();
    _teamStore = context.read();
    _classificationStore = context.read();
    _zollSdkStore = context.read();

    Future.wait([
      _reportStore.getReports(),
      _teamStore.getTeams(),
      _classificationStore.getAllClassifications(),
    ]).then((_) {
      _reportStore.reports?.forEach((element) {
        element.teamStore = _teamStore;
        element.classificationStore = _classificationStore;
      });
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlider(),
            const SizedBox(height: 16),
            _buildConnectedDevice(),
            const SizedBox(height: 8),
            _zollSdkStore.selectedDevice != null
                ? IntrinsicWidth(
                    child: ListTile(
                        tileColor: const Color(0xFFF5F5F5),
                        title:
                            Text(_zollSdkStore.selectedDevice!.serialNumber)),
                  )
                : Container(),
            const SizedBox(height: 16),
            _buildReportList(),
            const SizedBox(height: 8),
            initialized
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _reportStore.reports?.length ?? 0,
                    separatorBuilder: (context, position) {
                      return const Divider(height: 1, color: Colors.black45);
                    },
                    itemBuilder: (context, position) {
                      return ReportListTile(
                        report: _reportStore.reports![position],
                        onTap: () {
                          _reportStore.setSelectingReport(
                              _reportStore.reports![position]);
                          Navigator.of(context)
                              .pushNamed(ReportRoutes.reportConfirmReport);
                        },
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final perItemWidth = width / 3;
      final currentRouteName = ModalRoute.of(context)?.settings.name;

      return Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Text("レポート管理",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff0082C8))),
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/img/create_report.png',
                      fit: BoxFit.cover),
                ),
                onTap: () {
                  if (currentRouteName == ReportRoutes.reportListReport) {
                    return;
                  }
                  Navigator.of(context)
                      .popAndPushNamed(ReportRoutes.reportListReport);
                },
              ),
            ],
          )),
          SizedBox.square(
            dimension: 16,
          ),
          Expanded(
              child: Column(
            children: [
              Text("データ参照",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff0082C8))),
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/img/data_viewer.png',
                      fit: BoxFit.cover),
                ),
                onTap: () {
                  if (currentRouteName ==
                      DataViewerRoutes.dataViewerListDevice) {
                    return;
                  }
                  if (_zollSdkStore.selectedDevice != null) {
                    Navigator.of(context)
                        .popAndPushNamed(DataViewerRoutes.dataViewerListCase);
                  } else {
                    Navigator.of(context)
                        .popAndPushNamed(DataViewerRoutes.dataViewerListDevice);
                  }
                },
              ),
            ],
          )),
          SizedBox.square(
            dimension: 16,
          ),
          Expanded(
              child: Column(
            children: [
              Text("データ参照（保存済）",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff0082C8))),
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/img/data_viewer_2.png',
                      fit: BoxFit.cover),
                ),
                onTap: () {
                  if (currentRouteName ==
                      DataViewerRoutes.dataViewerListDevice) {
                    return;
                  }
                  Navigator.of(context).popAndPushNamed(
                      DataViewerRoutes.dataViewerListDownloadedCase);
                },
              ),
            ],
          ))
        ],
      );
    });
  }

  Widget _buildConnectedDevice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/icons/C_X Series.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              "接続先情報",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/icons/C_Report.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              "レポート一覧",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
