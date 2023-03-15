import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/ui/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class ListCaseScreenArguments {
  final XSeriesDevice device;
  final Report report;

  ListCaseScreenArguments({required this.device, required this.report});
}

class ListCaseScreen extends StatefulWidget {
  const ListCaseScreen({super.key});

  @override
  _ListCaseScreenState createState() => _ListCaseScreenState();
}

class _ListCaseScreenState extends State<ListCaseScreen> with RouteAware {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late Report _report;
  late ScrollController scrollController;

  late XSeriesDevice device;
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
    final args =
        ModalRoute.of(context)!.settings.arguments as ListCaseScreenArguments;
    device = args.device;
    _report = args.report;

    _hostApi = Provider.of<ZollSdkHostApi>(context);
    _zollSdkStore = context.read();
    print('device serial number');
    print(device.serialNumber);
    _zollSdkStore.caseListItems['serialNumber'] = ObservableList.of([
      CaseListItem(
          caseId: 'caseId',
          startTime: "2023-02-02T05:19:43Z",
          endTime: "2024-02-02T06:29:04Z")
    ]);
    _hostApi.deviceGetCaseList(device, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: _buildBackButton(),
      leadingWidth: 88,
      actions: _buildActions(),
      title: 'get_xseries_data'.i18n(),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      // _buildCreateReportButton(),
    ];
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: Container(
        width: 12,
        child: const Icon(Icons.arrow_back_ios),
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
        Observer(
            builder: (context) =>
                _zollSdkStore.caseListItems[device.serialNumber] != null
                    ? _buildMainContent()
                    : const CustomProgressIndicatorWidget()),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text("please_choose_case".i18n(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.black, fontSize: 18)),
        ),
        Expanded(
          child: Observer(
            builder: (context) {
              final cases = _zollSdkStore.caseListItems[device.serialNumber]!;
              return Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: cases.length,
                  itemBuilder: (context, index) => ListTile(
                      title: Text(
                          '${_formatTime(cases[index].startTime)}〜${_formatTime(cases[index].endTime)}'),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.listEvent,
                            arguments: ListEventScreenArguments(
                                device: device,
                                caseId: cases[index].caseId,
                                report: _report));
                      }),
                  separatorBuilder: (context, index) => const Divider(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _formatTime(String? time) {
    // return time;
    if (time == null) return '';
    return AppConstants.dateTimeFormat.format(DateTime.parse(time).toLocal());
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
