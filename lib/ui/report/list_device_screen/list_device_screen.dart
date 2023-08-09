import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:localization/localization.dart';

class ListDeviceScreen extends StatefulWidget {
  const ListDeviceScreen({super.key});

  @override
  _ListDeviceScreenState createState() => _ListDeviceScreenState();
}

class _ListDeviceScreenState extends State<ListDeviceScreen> with RouteAware {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late ScrollController scrollController;
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
  void didPush() {
    _hostApi = context.read();
    _zollSdkStore = context.read();
    // _zollSdkStore.devices = ObservableList();
    // _zollSdkStore.devices
    // .add(XSeriesDevice(address: 'address', serialNumber: 'Sample Device'));
    // _zollSdkStore.devices
    //     .add(XSeriesDevice(address: 'address', serialNumber: 'serialNumber1'));
    if (_zollSdkStore.devices
            .indexWhere((e) => e.serialNumber == 'Sample Device') ==
        -1) {
      _zollSdkStore.devices.add(
          XSeriesDevice(address: 'address', serialNumber: 'Sample Device'));
    }
    _hostApi.browserStart();
  }

  // @override
  // void didPop() {
  //   _hostApi.browserStop();
  // }

  // @override
  // void didPopNext() async {
  //   await _hostApi.browserStop();
  //   await _hostApi.browserStart();
  // }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      leadings: [_buildBackButton()],
      leadingWidth: 88,
      actions: _buildActions(),
      body: _buildBody(),
      title: 'get_xseries_data'.i18n(),
      icon: const Icon(Icons.home),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      // _buildCreateReportButton(),
    ];
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
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text("please_choose_device".i18n(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.black, fontSize: 18)),
        ),
        Expanded(
          child: Observer(
            builder: (context) => Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: ListView.separated(
                controller: scrollController,
                itemCount: _zollSdkStore.devices.length,
                itemBuilder: (context, index) => ListTile(
                    title: Text(_zollSdkStore.devices[index].serialNumber),
                    onTap: () {
                      _zollSdkStore.selectedDevice =
                          _zollSdkStore.devices[index];
                      Navigator.of(context)
                          .pushNamed(ReportRoutes.reportListCase);
                    }),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ),
        ),
      ],
    );
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
