import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/ui/data_viewer/choose_function_screen/choose_function_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/app_drawer.dart';
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
    final device = _zollSdkStore.selectedDevice;
    setState(() {
      cases = _zollSdkStore.caseListItems[device?.serialNumber];
    });
    reactionDisposer?.call();
    reactionDisposer = autorun((_) {
      final storeCases = _zollSdkStore.caseListItems[device?.serialNumber];
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
    _zollSdkStore.caseListItems['Sample Device'] = [
      CaseListItem(
          caseId: 'AR16D018896-20230227-161027-3131',
          startTime: "2023-02-22T14:39:20",
          endTime: "2023-02-22T15:45:36"),
      CaseListItem(
          caseId: 'AR16D018896-20230227-161639-3132',
          startTime: "2023-02-22T15:45:36",
          endTime: "2023-02-22T15:53:55"),
      CaseListItem(
          caseId: 'AR16D018896-20230227-161728-3133',
          startTime: "2023-02-22T15:53:55",
          endTime: "2023-02-22T16:03:56"),
      CaseListItem(
          caseId: 'AR16D018896-20230227-161849-3134',
          startTime: "2023-02-22T16:03:56",
          endTime: "2023-02-22T16:11:10"),
      CaseListItem(
          caseId: 'AR16D018896-20230227-161938-3135',
          startTime: "2023-02-22T16:11:10",
          endTime: "2023-02-27T16:06:38"),
      CaseListItem(
          caseId: 'AR16D018896-20230322-143534-3141',
          startTime: "2023-03-13T12:34:51",
          endTime: "2023-03-15T17:57:45")
    ];
    _hostApi.deviceGetCaseList(device!, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: AppDrawer(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      actions: _buildActions(),
      title: 'Case選択',
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      // _buildCreateReportButton(),
      hasNewData
          ? Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    cases = [
                      ..._zollSdkStore.caseListItems[
                          _zollSdkStore.selectedDevice?.serialNumber]!
                    ];
                    hasNewData = false;
                  });
                },
                label: const Text("更新"),
                icon: const Icon(Icons.refresh),
              ),
            )
          : Container()
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
                  Navigator.of(context).pushNamed(
                      DataViewerRoutes.dataViewerChooseFunction,
                      arguments: ChooseFunctionScreenArguments(
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
