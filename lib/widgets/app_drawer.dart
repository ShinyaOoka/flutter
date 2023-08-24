import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/ui/alerts/show_leave_create_report_dialog.dart';
import 'package:ak_azm_flutter/ui/alerts/show_leave_edit_report_dialog.dart';
import 'package:ak_azm_flutter/utils/routes/app.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
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
  }

  Future<bool> shouldLeaveScreen(BuildContext context) async {
    final currentRouteName = ModalRoute.of(context)?.settings.name;

    if (currentRouteName == ReportRoutes.reportCreateReport) {
      return await showLeaveCreateReportDialog(context);
    }
    if (currentRouteName == ReportRoutes.reportEditReport) {
      return await showLeaveEditReportDialog(context);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final currentRouteName = ModalRoute.of(context)?.settings.name;
    final isDataViewerRoute =
        DataViewerRoutes.routes.containsKey(currentRouteName);
    final isReportRoute = ReportRoutes.routes.containsKey(currentRouteName);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 80,
            child: DrawerHeader(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0),
              child: Image(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.fitHeight,
                height: 60,
              ),
            ),
          ),
          _buildNavigationListTile(
              context, const Icon(Icons.home), const Text("ホーム"), () {
            if (currentRouteName == AppRoutes.top) {
              return;
            }
            Navigator.of(context).popAndPushNamed(AppRoutes.top);
            Scaffold.of(context).openDrawer();
          }),
          _buildNavigationListTile(
              context, const Icon(Icons.description), const Text("レポート管理"), () {
            if (currentRouteName == ReportRoutes.reportListReport) {
              return;
            }
            Navigator.of(context)
                .popAndPushNamed(ReportRoutes.reportListReport);
          }),
          _buildNavigationListTile(
              context, const Icon(Icons.data_thresholding), const Text("データ参照"),
              () {
            if (currentRouteName == DataViewerRoutes.dataViewerListDevice) {
              Navigator.of(context).pop();
              return;
            }
            if (_zollSdkStore.selectedDevice != null) {
              Navigator.of(context)
                  .popAndPushNamed(DataViewerRoutes.dataViewerListCase);
            } else {
              Navigator.of(context)
                  .popAndPushNamed(DataViewerRoutes.dataViewerListDevice);
            }
          }),
          _buildNavigationListTile(
              context, const Icon(Icons.home), const Text("データ参照（保存済）"), () {
            if (currentRouteName ==
                DataViewerRoutes.dataViewerListDownloadedCase) {
              return;
            }
            Navigator.of(context)
                .popAndPushNamed(DataViewerRoutes.dataViewerListDownloadedCase);
          }),
          if (_zollSdkStore.selectedDevice != null)
            _buildNavigationListTile(context, const Icon(Icons.phonelink_erase),
                const Text('接続機器変更'), () {
              if (isDataViewerRoute) {
                Navigator.of(context)
                    .popAndPushNamed(DataViewerRoutes.dataViewerListDevice);
              } else if (isReportRoute) {
                Navigator.of(context)
                    .popAndPushNamed(ReportRoutes.reportChangeDevice);
              } else {
                Navigator.of(context).popAndPushNamed(AppRoutes.topListDevice);
              }
            }),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("情報"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('情報'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Image(
                              image: AssetImage('assets/logo.png'),
                              fit: BoxFit.fitHeight,
                              height: 60,
                            ),
                            SizedBox(height: 32),
                            Text('アプリ名: CodeMate'),
                            Text('バーション: 0.0.1'),
                            SizedBox(height: 32),
                            Text(
                              'Copyright © Asahi Kasei Corporation. All rights reserved.',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Copyright © Asahi Kasei ZOLL Medical Corporation. All Rights Reserved.',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Portions copyright © ZOLL Medical Corporation.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ]);
                  });
            },
          ),
          if (_zollSdkStore.selectedDevice != null) ...[
            const Divider(),
            ListTile(
              title:
                  Text('接続中機器: ${_zollSdkStore.selectedDevice?.serialNumber}'),
            ),
          ]
        ],
      ),
    );
  }

  ListTile _buildNavigationListTile(
      BuildContext context, Widget leading, Widget title, Function() onTap) {
    return ListTile(
      leading: leading,
      title: title,
      onTap: () async {
        final shouldLeave = await shouldLeaveScreen(context);
        if (!shouldLeave || !mounted) return;
        onTap();
      },
    );
  }
}
