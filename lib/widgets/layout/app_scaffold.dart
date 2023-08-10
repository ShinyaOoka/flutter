import 'package:ak_azm_flutter/stores/ui/ui_store.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/utils/routes/app.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';

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
                  decoration: const BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.black38))),
                  child: SafeArea(
                    child: Column(
                      children: [
                        const Image(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.fitHeight,
                          height: 60,
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.home),
                                title: const Text("ホーム"),
                                onTap: () {
                                  if (currentRouteName == AppRoutes.top) {
                                    return;
                                  }
                                  Navigator.of(context)
                                      .popAndPushNamed(AppRoutes.top);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.home),
                                title: const Text("レポート管理"),
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
                                leading: const Icon(Icons.home),
                                title: const Text("データ参照"),
                                onTap: () {
                                  if (currentRouteName ==
                                      DataViewerRoutes.dataViewerListDevice) {
                                    return;
                                  }
                                  Navigator.of(context).popAndPushNamed(
                                      DataViewerRoutes.dataViewerListDevice);
                                  if (_zollSdkStore.selectedDevice != null) {
                                    Navigator.of(context).pushNamed(
                                        DataViewerRoutes.dataViewerListCase);
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.home),
                                title: const Text("データ参照（保存済）"),
                                onTap: () {
                                  if (currentRouteName ==
                                      DataViewerRoutes
                                          .dataViewerListDownloadedCase) {
                                    return;
                                  }
                                  Navigator.of(context).popAndPushNamed(
                                      DataViewerRoutes
                                          .dataViewerListDownloadedCase);
                                },
                              ),
                              _zollSdkStore.selectedDevice != null
                                  ? ListTile(
                                      leading:
                                          const Icon(Icons.phonelink_erase),
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
                                leading: const Icon(Icons.home),
                                title: const Text("情報"),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: const Text('情報'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'assets/logo.png'),
                                                  fit: BoxFit.fitHeight,
                                                  height: 60,
                                                ),
                                                SizedBox(height: 32),
                                                Text('アプリ名: CodeMate'),
                                                Text('バーション: 0.0.1'),
                                                SizedBox(height: 32),
                                                Text(
                                                  'Copyright © Asahi Kasei Corporation. All rights reserved.',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                Text(
                                                  'Copyright © Asahi Kasei ZOLL Medical Corporation. All Rights Reserved.',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                Text(
                                                  'Portions copyright © ZOLL Medical Corporation.',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
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
                                      const Divider(),
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
            icon: const Icon(Icons.menu),
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
