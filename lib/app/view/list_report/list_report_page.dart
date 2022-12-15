import 'dart:async';

import 'package:ak_azm_flutter/app/viewmodel/base_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../module/common/config.dart';
import '../../module/res/style.dart';
import '../empty/empty_page.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import '../widget_utils/buttons/filled_button.dart';
import '../widget_utils/custom/default_loading_progress.dart';
import '../widget_utils/custom/loadmore.dart';
import 'list_report_viewmodel.dart';
import 'item_account.dart';

class ListReportPage extends PageProvideNode<ListReportViewModel> {
  ListReportPage({Key? key}) : super(key: key, params: []);

  @override
  Widget buildContent(BuildContext context) {
    return ChooseAccountContent(viewModel);
  }
}

class ChooseAccountContent extends StatefulWidget {
  final ListReportViewModel _chooseAccountViewModel;

  ChooseAccountContent(this._chooseAccountViewModel);

  @override
  State<ChooseAccountContent> createState() => _ChooseAccountContentState();
}

class _ChooseAccountContentState extends State<ChooseAccountContent>
    with SingleTickerProviderStateMixin {
  ListReportViewModel get chooseAccountViewModel =>
      widget._chooseAccountViewModel;

  @override
  void initState() {
    chooseAccountViewModel.scrollController.addListener(() {
      chooseAccountViewModel.onScroll();
    });
    chooseAccountViewModel.getLoginData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () => chooseAccountViewModel.onDoubleBackToExit(),
        child: BaseScaffoldSafeArea(
          customAppBar: AppBar(
            backgroundColor: kColor4472C4,
            centerTitle: true,
            title: Text(
              'LIST REPORT',
              // style: Theme.of(context).appBarTheme.titleTextStyle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                child: Text('Create',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () => chooseAccountViewModel.openCreateReport(),
              ),
              TextButton(
                child: Text('Edit',
                    // style: Theme.of(context).appBarTheme.titleTextStyle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () => chooseAccountViewModel.openEditReport(),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          onBackPress: () => chooseAccountViewModel.onDoubleBackToExit(),
          transparentStatusBar: 0.2,
          backgroundColor: kColorF8F9FA,
          body: Stack(
            children: [
              /*Container(
                padding: EdgeInsets.only(bottom: size_100_w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //body

                    Expanded(
                      child: Consumer<ListReportViewModel>(
                        builder: (context, value, child) {
                          switch (value.loadingState) {
                            case LoadingState.LOADING:
                              return BuildProgressLoading();
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
                                imgEmpty: 'assets/images/img_empty_shop.svg',
                                emptyText: LocaleKeys.no_account.tr(),
                              );
                            case LoadingState.DONE:
                              return RefreshIndicator(
                                color: kColorPrimary,
                                onRefresh: () async {
                                  return Future.delayed(
                                    Duration(milliseconds: 2000),
                                    () {
                                      value.refreshData();
                                    },
                                  );
                                },
                                child: CustomScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  controller: value.scrollController,
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          return ItemAccount(
                                            loginConfig:
                                                value.loginDataList[index],
                                            onDeleteItem: () =>
                                                chooseAccountViewModel
                                                    .deleteAccount(value
                                                        .loginDataList[index]),
                                            onClickItem: () {
                                              value.signInApi(
                                                  value.loginDataList[index]);
                                            },
                                          );
                                        },
                                        childCount: value.loginDataList.length,
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
              ),*/

              //Button goto sign in
              Positioned(
                // draw a red marble
                bottom: size_30_w,
                left: size_26_w,
                right: size_26_w,
                child: FilledButton(
                  color: kColor4472C4,
                  text: 'Preview Report',
                  onPress: () => chooseAccountViewModel.openPreviewReport(),
                ),
              ),
            ],
          ),
        ));
  }
}
