import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/stores/ui/ui_store.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/utils/routes/app.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/app_drawer.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
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

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.actions,
    this.leadings,
    this.leadingWidth,
    this.icon,
  });

  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final List<Widget>? leadings;
  final String? title;
  final double? leadingWidth;
  final Widget? icon;

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> with RouteAware {
  late UiStore _uiStore;

  late ZollSdkStore _zollSdkStore;
  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

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
    _zollSdkStore = context.read();
    _uiStore = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final currentRouteName = ModalRoute.of(context)?.settings.name;
    final isDataViewerRoute =
        DataViewerRoutes.routes.containsKey(currentRouteName);
    final isReportRoute = ReportRoutes.routes.containsKey(currentRouteName);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          floatingActionButton: widget.floatingActionButton,
          body: Row(
            children: [
              Observer(builder: (context) {
                return Container(
                  width: _uiStore.showDrawer ? 200 : 0,
                  decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.black38))),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.fitHeight,
                          height: 60,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: Icon(Icons.home),
                                title: Text("ホーム"),
                                onTap: () {
                                  if (currentRouteName == AppRoutes.top) {
                                    return;
                                  }
                                  Navigator.of(context)
                                      .popAndPushNamed(AppRoutes.top);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.home),
                                title: Text("レポート管理"),
                                onTap: () {
                                  if (currentRouteName ==
                                      ReportRoutes.reportListReport) {
                                    return;
                                  }
                                  Navigator.of(context).popAndPushNamed(
                                      ReportRoutes.reportListReport);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.home),
                                title: Text("データ参照"),
                                onTap: () {
                                  if (currentRouteName ==
                                      DataViewerRoutes.dataViewerListDevice) {
                                    return;
                                  }
                                  if (_zollSdkStore.selectedDevice != null) {
                                    Navigator.of(context).popAndPushNamed(
                                        DataViewerRoutes.dataViewerListCase);
                                  } else {
                                    Navigator.of(context).popAndPushNamed(
                                        DataViewerRoutes.dataViewerListDevice);
                                  }
                                },
                              ),
                              _zollSdkStore.selectedDevice != null
                                  ? ListTile(
                                      leading: Icon(Icons.phonelink_erase),
                                      title: const Text('接続機器変更'),
                                      onTap: () {
                                        if (isDataViewerRoute) {
                                          Navigator.of(context).popAndPushNamed(
                                              DataViewerRoutes
                                                  .dataViewerListDevice);
                                        } else if (isReportRoute) {
                                          Navigator.of(context).popAndPushNamed(
                                              ReportRoutes.reportChangeDevice);
                                        } else {
                                          Navigator.of(context).popAndPushNamed(
                                              DataViewerRoutes
                                                  .dataViewerListDevice);
                                        }
                                      },
                                    )
                                  : Container(),
                              ListTile(
                                leading: Icon(Icons.home),
                                title: Text("情報"),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text('情報'),
                                            content: RichText(
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    children: [
                                                  TextSpan(text: 'アプリ名\n'),
                                                  TextSpan(
                                                      text: 'バーション: 0.0.1'),
                                                ])),
                                            actions: [
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                              ),
                                            ]);
                                      });
                                },
                              ),
                              ..._zollSdkStore.selectedDevice != null
                                  ? [
                                      Divider(),
                                      ListTile(
                                        title: Text(
                                            '接続中機器: ${_zollSdkStore.selectedDevice?.serialNumber}'),
                                      ),
                                    ]
                                  : [],
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
              Expanded(
                child: Scaffold(
                  appBar: _buildAppBar(),
                  body: widget.body,
                ),
              )
            ],
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: widget.title,
      actions: widget.actions,
      icon: widget.icon,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _uiStore.setShowDrawer(!_uiStore.showDrawer);
            },
          ),
          ...widget.leadings ?? [],
        ],
      ),
      leadingWidth: 56 + (widget.leadingWidth ?? 0),
    );
  }
}
