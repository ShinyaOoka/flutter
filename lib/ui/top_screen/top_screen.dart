import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/app_drawer.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report_list_tile.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:tuple/tuple.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSlider(),
          SizedBox(height: 16),
          _buildConnectedDevice(),
          SizedBox(height: 8),
          _zollSdkStore.selectedDevice != null
              ? IntrinsicWidth(
                  child: ListTile(
                      tileColor: const Color(0xFFF5F5F5),
                      title: Text(_zollSdkStore.selectedDevice!.serialNumber)),
                )
              : Container(),
          SizedBox(height: 16),
          _buildReportList(),
          SizedBox(height: 8),
          initialized
              ? ListView.separated(
                  shrinkWrap: true,
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
    );
  }

  Widget _buildSlider() {
    return Container(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: [
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.orange
              ][index],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(width: 10);
        },
        itemCount: 4,
      ),
    );
  }

  Widget _buildConnectedDevice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.home),
            SizedBox(width: 8),
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
            Icon(Icons.home),
            SizedBox(width: 8),
            Text(
              "レポート一覧",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
