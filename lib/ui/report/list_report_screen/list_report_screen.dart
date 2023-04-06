import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
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
import 'package:tuple/tuple.dart';

enum SelectionMode { none, copy, delete }

class ListReportScreen extends StatefulWidget {
  const ListReportScreen({super.key});

  @override
  _ListReportScreenState createState() => _ListReportScreenState();
}

class _ListReportScreenState extends State<ListReportScreen> with RouteAware {
  late ReportStore _reportStore;
  late TeamStore _teamStore;
  late ClassificationStore _classificationStore;
  late ScrollController scrollController;
  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();
  SelectionMode mode = SelectionMode.none;
  Set<int>? selectingReports;

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
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _reportStore = context.read();
    _teamStore = context.read();
    _classificationStore = context.read();

    _reportStore.getReports();
    _teamStore.getTeams();
    _classificationStore.getAllClassifications();
  }

  @override
  void didPopNext() {
    _reportStore.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton:
            mode == SelectionMode.none ? _buildCreateReportButton() : null,
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 80,
                child: DrawerHeader(
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.fitHeight,
                    height: 60,
                  ),
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                ),
              ),
              ListTile(
                title: const Text('レポート作成'),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name ==
                      ReportRoutes.reportListReport) {
                    Navigator.of(context).pop();
                    return;
                  }
                  Navigator.of(context)
                      .popAndPushNamed(ReportRoutes.reportListReport);
                },
              ),
              ListTile(
                title: const Text('データビューアー（仮）'),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name ==
                      DataViewerRoutes.dataViewerListDevice) {
                    Navigator.of(context).pop();
                    return;
                  }
                  Navigator.of(context)
                      .popAndPushNamed(DataViewerRoutes.dataViewerListDevice);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'list_report'.i18n(),
      actions: _buildActions(context),
      leading: mode != SelectionMode.none ? _buildBackButton() : null,
      leadingWidth: mode != SelectionMode.none ? 102 : null,
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const Icon(Icons.cancel),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('ｷｬﾝｾﾙ'.i18n()),
      onPressed: () {
        setState(() {
          mode = SelectionMode.none;
        });
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    switch (mode) {
      case SelectionMode.none:
        return [_buildSelectButton()];
      case SelectionMode.copy:
        return [_buildCopyButton()];
      case SelectionMode.delete:
        return [_buildDeleteButton()];
    }
  }

  Widget _buildSelectButton() {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).primaryColor,
      ),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
              value: 0,
              child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: Icon(Icons.content_copy),
                  title: Text('複写登録'))),
          const PopupMenuItem(
              value: 1,
              child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: Icon(Icons.delete),
                  title: Text('選択削除'))),
        ];
      },
      onSelected: (value) async {
        switch (value) {
          case 0:
            setState(() {
              mode = SelectionMode.copy;
              selectingReports = {};
            });
            break;
          case 1:
            setState(() {
              mode = SelectionMode.delete;
              selectingReports = {};
            });
            break;
        }
      },
    );
  }

  Widget _buildDeleteButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        onPressed: () async {
          if (selectingReports?.isEmpty == true) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('削除対象無エラー'),
                content: const Text('削除対象が選択されていません。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            return;
          }
          final result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('選択削除確認'),
                  content: const Text('選択したデータを削除します。よろしいですか？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'はい',
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                    ),
                  ],
                );
              });
          if (result != true) {
            return;
          }
          final reportIds = selectingReports!
              .map((e) => _reportStore.reports![e].id!)
              .toList();
          await _reportStore.deleteReports(reportIds);
          await _reportStore.getReports();
          if (!mounted) return;
          FlushbarHelper.createInformation(
            message: '削除処理を完了しました。',
            duration: const Duration(seconds: 3),
          ).show(context);
          setState(() {
            mode = SelectionMode.none;
          });
        },
        icon: const Icon(Icons.delete),
        label: Text(
          '削除',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        onPressed: () async {
          if (selectingReports?.isEmpty == true) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('複写対象無エラー'),
                content: const Text('複写対象が選択されていません。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            return;
          }
          final fromReport = _reportStore.reports![selectingReports!.first];
          final toReport = Report();

          toReport.senseTime = fromReport.senseTime;
          toReport.commandTime = fromReport.commandTime;
          toReport.dispatchTime = fromReport.dispatchTime;
          toReport.onSiteArrivalTime = fromReport.onSiteArrivalTime;
          toReport.contactTime = fromReport.contactTime;
          toReport.inVehicleTime = fromReport.inVehicleTime;
          toReport.startOfTransportTime = fromReport.startOfTransportTime;
          toReport.hospitalArrivalTime = fromReport.hospitalArrivalTime;
          toReport.familyContact = fromReport.familyContact;
          toReport.familyContactTime = fromReport.familyContactTime;
          toReport.policeContact = fromReport.policeContact;
          toReport.policeContactTime = fromReport.policeContactTime;
          toReport.timeOfArrival = fromReport.timeOfArrival;
          toReport.returnTime = fromReport.returnTime;

          toReport.typeOfAccident = fromReport.typeOfAccident;
          toReport.dateOfOccurrence = fromReport.dateOfOccurrence;
          toReport.timeOfOccurrence = fromReport.timeOfOccurrence;
          toReport.placeOfIncident = fromReport.placeOfIncident;
          toReport.placeOfDispatch = fromReport.placeOfDispatch;
          toReport.accidentSummary = fromReport.accidentSummary;
          toReport.adl = fromReport.adl;
          toReport.witnesses = fromReport.witnesses;
          toReport.bystanderCpr = fromReport.bystanderCpr;
          toReport.bystanderCprTime = fromReport.bystanderCprTime;
          toReport.trafficAccidentSeatbelt = fromReport.trafficAccidentSeatbelt;
          toReport.trafficAccidentAirbag = fromReport.trafficAccidentAirbag;
          toReport.trafficAccidentChildseat =
              fromReport.trafficAccidentChildseat;
          toReport.trafficAccidentHelmet = fromReport.trafficAccidentHelmet;
          toReport.trafficAccidentUnknown = fromReport.trafficAccidentUnknown;
          toReport.verbalGuidance = fromReport.verbalGuidance;
          toReport.verbalGuidanceText = fromReport.verbalGuidanceText;

          toReport.perceiverName = fromReport.perceiverName;
          toReport.typeOfDetection = fromReport.typeOfDetection;
          toReport.callerName = fromReport.callerName;
          toReport.callerTel = fromReport.callerTel;

          _reportStore.selectingReport = toReport;
          Navigator.of(context).pushNamed(ReportRoutes.reportCreateReport);
          setState(() {
            mode = SelectionMode.none;
          });
        },
        icon: const Icon(Icons.note_add),
        label: Text(
          '複写',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateReportButton() {
    return FloatingActionButton(
      onPressed: () {
        _reportStore.selectingReport = Report();
        Navigator.of(context).pushNamed(ReportRoutes.reportCreateReport);
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _reportStore.loading
            ? const CustomProgressIndicatorWidget()
            : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    return Observer(builder: (context) {
      return _reportStore.reports != null
          ? Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: ListView.separated(
                controller: scrollController,
                itemCount: _reportStore.reports!.length,
                separatorBuilder: (context, position) {
                  return const Divider(height: 1, color: Colors.black45);
                },
                itemBuilder: (context, position) {
                  return _buildListItem(position);
                },
              ),
            )
          : Center(child: Text('no_report_found'.i18n()));
    });
  }

  Widget _buildListTileTitle(int position) {
    final item = _reportStore.reports![position];
    final team = _teamStore.teams[item.teamCd];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
              TextSpan(
                  text: '発生日時：',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                style: const TextStyle(fontWeight: FontWeight.bold),
                text:
                    '${item.dateOfOccurrence != null ? AppConstants.dateFormat.format(item.dateOfOccurrence!) : '----/--/--'} ${item.timeOfOccurrence?.format(context) ?? '--:--'}',
              ),
            ])),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${'list_report_team_name'.i18n()} : ',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          TextSpan(
              text: team?.name ?? 'なし',
              style: Theme.of(context).textTheme.bodyMedium)
        ]))
      ],
    );
  }

  Widget _buildListTileSubtitle(int position) {
    final item = _reportStore.reports![position];
    final typeOfAccident = item.typeOfAccident != null
        ? _classificationStore.classifications[
            Tuple2(AppConstants.typeOfAccidentCode, item.typeOfAccident!)]
        : null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${'type_of_accident'.i18n()} : ',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          TextSpan(
              text: typeOfAccident?.value ?? 'なし',
              style: Theme.of(context).textTheme.bodyMedium)
        ])),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${'accident_summary'.i18n()} : ',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          TextSpan(
              text: item.accidentSummary ?? 'なし',
              style: Theme.of(context).textTheme.bodyMedium)
        ]))
      ],
    );
  }

  Widget _buildListItem(int position) {
    final item = _reportStore.reports![position];
    switch (mode) {
      case SelectionMode.none:
        return ListTile(
          onTap: () {
            _reportStore.setSelectingReport(item);
            Navigator.of(context).pushNamed(ReportRoutes.reportConfirmReport);
          },
          dense: true,
          tileColor: const Color(0xFFF5F5F5),
          title: _buildListTileTitle(position),
          subtitle: _buildListTileSubtitle(position),
        );
      case SelectionMode.delete:
        return CheckboxListTile(
          value: selectingReports?.contains(position),
          onChanged: (value) {
            setState(() {
              if (selectingReports?.contains(position) == true) {
                selectingReports?.remove(position);
              } else {
                selectingReports?.add(position);
              }
            });
          },
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: const Color(0xFFF5F5F5),
          title: _buildListTileTitle(position),
          subtitle: _buildListTileSubtitle(position),
        );
      case SelectionMode.copy:
        return RadioListTile(
          value: position,
          groupValue: selectingReports?.isNotEmpty == true
              ? selectingReports?.single
              : null,
          onChanged: (value) {
            setState(() {
              if (selectingReports?.contains(position) == true) {
                selectingReports?.clear();
              } else {
                selectingReports?.clear();
                selectingReports?.add(position);
              }
            });
          },
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: const Color(0xFFF5F5F5),
          title: _buildListTileTitle(position),
          subtitle: _buildListTileSubtitle(position),
        );
    }
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_reportStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_reportStore.errorStore.errorMessage);
        }

        return const SizedBox.shrink();
      },
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
