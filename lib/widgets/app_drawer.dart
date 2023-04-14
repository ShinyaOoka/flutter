import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
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
          ListTile(
            leading: Icon(Icons.description),
            title: const Text('レポート作成'),
            onTap: () {
              if (currentRouteName == ReportRoutes.reportListReport) {
                Navigator.of(context).pop();
                return;
              }
              Navigator.of(context)
                  .popAndPushNamed(ReportRoutes.reportListReport);
            },
          ),
          ListTile(
            leading: Icon(Icons.data_thresholding),
            title: const Text('データビューアー（仮）'),
            onTap: () {
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
            },
          ),
          isDataViewerRoute &&
                  currentRouteName != DataViewerRoutes.dataViewerListDevice
              ? ListTile(
                  leading: Icon(Icons.phonelink_erase),
                  title: const Text('接続機器変更'),
                  onTap: () {
                    Navigator.of(context)
                        .popAndPushNamed(DataViewerRoutes.dataViewerListDevice);
                  },
                )
              : Container(),
          ListTile(
            leading: Icon(Icons.info),
            title: const Text('情報'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('情報'),
                        content: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                              TextSpan(text: 'アプリ名\n'),
                              TextSpan(text: 'バーション: 0.0.1'),
                            ])),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ]);
                  });
            },
          ),
        ],
      ),
    );
  }
}
