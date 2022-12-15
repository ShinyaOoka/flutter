import 'dart:io';
import 'package:ak_azm_flutter/app/module/network/network_util.dart';
import 'package:ak_azm_flutter/app/view/webview/webview_viewmodel.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/base_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../di/injection.dart';
import '../../model/webview_param.dart';
import '../../module/local_storage/shared_pref_manager.dart';
import '../../module/res/colors.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../widget_utils/custom/default_loading_progress.dart';
import '../widget_utils/custom/appbar_custom.dart';

class WebviewPage extends PageProvideNode<WebviewViewModel> {
  WebviewPage(WebviewParam? webviewParam) : super(params: [webviewParam]);

  @override
  Widget buildContent(BuildContext context) {
    return _WebviewContentPage(viewModel);
  }
}

class _WebviewContentPage extends StatefulWidget {
  final WebviewViewModel _webviewViewModel;

  _WebviewContentPage(this._webviewViewModel);

  @override
  _WebviewContentPageState createState() => _WebviewContentPageState();
}

class _WebviewContentPageState extends State<_WebviewContentPage> {
  WebviewViewModel get webviewViewModel => widget._webviewViewModel;
  var headers = {"Cookie": "tz=Asia/Saigon; frontend_lang=en_US; cids=1; session_id=${getIt<UserSharePref>().getAppToken()}"};
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print('Header Webview: ${headers}');
    return BaseScaffold(
      title: webviewViewModel.webviewParam?.title ?? '',
      body: Stack(
        children: <Widget>[
          WebView(
            onWebViewCreated: (controller) {
              controller.loadUrl(
                webviewViewModel.webviewParam?.url ?? '',
                headers: headers,
              );
            },
            key: UniqueKey(),
            javascriptMode: JavascriptMode.unrestricted,
            backgroundColor: Colors.white,
            onPageFinished: (finish) => webviewViewModel.loading = false,
          ),
          _buildLoading(),
        ],
      ),
    );
  }

  Consumer<WebviewViewModel> _buildLoading() {
    return Consumer<WebviewViewModel>(
      builder: (context, value, child) {
        return value.loading ? BuildProgressLoading() : Stack();
      },
    );
  }
}
