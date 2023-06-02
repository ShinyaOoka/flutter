import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/ui/report/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class ListCaseScreen extends StatefulWidget {
  const ListCaseScreen({super.key});

  @override
  _ListCaseScreenState createState() => _ListCaseScreenState();
}

class _ListCaseScreenState extends State<ListCaseScreen> with RouteAware {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late ScrollController scrollController;

  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();
  List<CaseListItem>? cases;
  bool hasNewData = false;
  ReactionDisposer? reactionDisposer;

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
    reactionDisposer?.call();
    _routeObserver.unsubscribe(this);
  }

  @override
  void didPush() {
    _zollSdkStore = context.read();
    final deviceSerialNumber = _zollSdkStore.selectedDevice?.serialNumber;
    setState(() {
      cases = _zollSdkStore.caseListItems[deviceSerialNumber];
    });
    reactionDisposer?.call();
    reactionDisposer = autorun((_) {
      final storeCases = _zollSdkStore.caseListItems[deviceSerialNumber];
      if (storeCases != null && cases == null) {
        setState(() {
          cases = storeCases;
        });
      } else if (cases != null && storeCases == null) {
        setState(() {
          hasNewData = false;
        });
      } else if (cases != null && storeCases != null) {
        setState(() {
          if (cases!.length != storeCases.length) {
            hasNewData = true;
          } else {
            for (int i = 0; i < cases!.length; i++) {
              final oldItem = cases![i];
              final newItem = storeCases[i];
              if (oldItem.caseId != newItem.caseId ||
                  oldItem.endTime != newItem.endTime ||
                  oldItem.startTime != newItem.startTime) {
                hasNewData = true;
                break;
              }
            }
          }
        });
      }
    });

    _hostApi = Provider.of<ZollSdkHostApi>(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (_zollSdkStore.caseListItems['Sample Device'] != null) {
        _zollSdkStore.caseListItems['Sample Device'] = [
          CaseListItem(
              caseId: 'caseId',
              startTime: "2023-02-02T05:19:44Z",
              endTime: "2024-02-02T06:29:04Z"),
          CaseListItem(
              caseId: 'caseId',
              startTime: "2023-02-02T05:19:44Z",
              endTime: "2024-02-02T06:29:04Z")
        ];
      } else {
        _zollSdkStore.caseListItems['Sample Device'] = [
          CaseListItem(
              caseId: 'caseId',
              startTime: "2023-02-02T05:19:43Z",
              endTime: "2024-02-02T06:29:04Z")
        ];
      }
    });
    _hostApi.deviceGetCaseList(_zollSdkStore.selectedDevice!, null);
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

      PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryColor,
        ),
        itemBuilder: (context) {
          final items = <PopupMenuEntry>[
            PopupMenuItem(
                value: 0,
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 10,
                    leading: const Icon(Icons.phonelink_erase),
                    title: Text('機器接続変更'.i18n()))),
            PopupMenuDivider(),
            PopupMenuItem(
                value: 99,
                enabled: false,
                child: ListTile(
                    title: Text(
                        '接続中機器: ${_zollSdkStore.selectedDevice!.serialNumber}'))),
          ];
          if (hasNewData) {
            items.insert(
              1,
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: const Icon(Icons.refresh),
                  title: Text('更新'),
                ),
              ),
            );
          }
          return items;
        },
        onSelected: (value) async {
          switch (value) {
            case 0:
              Navigator.of(context).pop();
              break;
            case 1:
              setState(() {
                cases = [
                  ..._zollSdkStore.caseListItems[
                      _zollSdkStore.selectedDevice?.serialNumber]!
                ];
                hasNewData = false;
              });
              break;
          }
        },
      )
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
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        // _handleErrorMessage(),
        cases != null
            ? _buildMainContent()
            : const CustomProgressIndicatorWidget()
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
            child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.separated(
            controller: scrollController,
            itemCount: cases!.length,
            itemBuilder: (context, index) => ListTile(
                title: Text(
                    '${_formatTime(cases![index].startTime)}〜${_formatTime(cases![index].endTime)}'),
                onTap: () {
                  Navigator.of(context).pushNamed(ReportRoutes.reportListEvent,
                      arguments: ListEventScreenArguments(
                          caseId: cases![index].caseId));
                }),
            separatorBuilder: (context, index) => const Divider(),
          ),
        )),
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
