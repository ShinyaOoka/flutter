import 'dart:async';

import 'package:ak_azm_flutter/app/module/common/extension.dart';
import 'package:ak_azm_flutter/app/module/event_bus/event_bus.dart';
import 'package:ak_azm_flutter/app/viewmodel/base_viewmodel.dart';
import 'package:ak_azm_flutter/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../module/common/config.dart';
import '../../module/res/style.dart';
import '../empty/empty_page.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import '../widget_utils/custom/default_loading_progress.dart';
import '../widget_utils/custom/loadmore.dart';
import 'item_report.dart';
import 'list_report_viewmodel.dart';

class ListReportPage extends PageProvideNode<ListReportViewModel> {
  ListReportPage({Key? key}) : super(key: key, params: []);

  @override
  Widget buildContent(BuildContext context) {
    return ListReportContent(viewModel);
  }
}

class ListReportContent extends StatefulWidget {
  final ListReportViewModel _listReportViewModel;

  ListReportContent(this._listReportViewModel);

  @override
  State<ListReportContent> createState() => _ListReportContentState();
}

class _ListReportContentState extends State<ListReportContent>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver  {
  ListReportViewModel get listReportViewModel =>
      widget._listReportViewModel;

  @override
  void initState() {
    initData();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ListReportContent oldWidget) {
    initData();
    super.didUpdateWidget(oldWidget);
  }


  @override
  void initData(){
    listReportViewModel.scrollController.addListener(() {
      listReportViewModel.onScroll();
    });
    //get data from db
    listReportViewModel.getAllMSClassification();
    listReportViewModel.getReports();
    //notify when add new report
    eventBus.on<AddReport>().listen((event) {
      listReportViewModel.refreshData();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        initData();
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState suspending');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => listReportViewModel.onDoubleBackToExit(),
        child: BaseScaffoldSafeArea(
          customAppBar: AppBar(
            backgroundColor: kColor4472C4,
            centerTitle: true,
            title: Text(
              LocaleKeys.report_list.tr(),
              style: TextStyle(
                fontSize: text_16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                child: const Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                ),
                onPressed: () => listReportViewModel.openCreateReport(),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          onBackPress: () => listReportViewModel.onDoubleBackToExit(),
          transparentStatusBar: 0.2,
          backgroundColor: kColorF8F9FA,
          body: Stack(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Consumer<ListReportViewModel>(
                        builder: (context, value, child) {
                          switch (value.loadingState) {
                            case LoadingState.LOADING:
                              return const BuildProgressLoading();
                            case LoadingState.EMPTY:
                              return EmptyWidget(
                                onRefresh: () {
                                  return Future.delayed(
                                    Duration(milliseconds: 2000),
                                    () {
                                      value.refreshData();
                                    },
                                  );
                                },
                                imgEmpty: '',
                                emptyText: LocaleKeys.empty_data.tr(),
                              );
                            case LoadingState.DONE:
                              return RefreshIndicator(
                                color: kColor4472C4,
                                onRefresh: () async {
                                  return Future.delayed(
                                    Duration(milliseconds: 2000),
                                    () {
                                      value.refreshData();
                                    },
                                  );
                                },
                                child: CustomScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  controller: value.scrollController,
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          return Column(
                                            children: [
                                              ItemReport(
                                                report: value.dtReports[index],
                                                msClassifications: value.msClassifications,
                                                onDeleteItem: () => null,
                                                onClickItem: () => listReportViewModel.openConfirmReport(value.dtReports[index]),
                                              ),
                                              index <= value.dtReports.length - 1 ? const Divider(height: 1, color: Colors.black26,) : Container()
                                            ],
                                          );
                                        },
                                        childCount: value.dtReports.length,
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child:
                                          value.canLoadMore && value.isLoading
                                              ? BuildLoadMore()
                                              : SizedBox(),
                                    ),
                                  ],
                                ),
                              );
                            default:
                              return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
