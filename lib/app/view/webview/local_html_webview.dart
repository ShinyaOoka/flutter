import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalHtmlWebView extends StatefulWidget {
  final String assetPath;

  const LocalHtmlWebView({
    Key? key,
    required this.assetPath,
  }) : super(key: key);

  @override
  _LocalHtmlWebViewState createState() => _LocalHtmlWebViewState();
}

class _LocalHtmlWebViewState extends State<LocalHtmlWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<void> _loadLocalHTML() async {
    final fileHtmlContents = await rootBundle.loadString(widget.assetPath);
    await _controller.loadUrl(
      Uri.dataFromString(
        fileHtmlContents,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _controller = controller;

        _loadLocalHTML();
      },
    );
  }
}
