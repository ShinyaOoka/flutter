import 'package:flutter/material.dart';

abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  ResumeResult resumeResult = new ResumeResult();
  bool _isPaused = false;

  AppLifecycleState lastAppState = AppLifecycleState.resumed;

  void onResume(){}

  void onPause(){}

  void onDetached(){}

  /// Use instead of Navigator.push(), it fires onResume() after route popped
  Future<T> push<T extends Object>(BuildContext context, Route<T> route,
      [String? source]) {
    _isPaused = true;
    onPause();

    return Navigator.of(context).push(route).then((value) {
      _isPaused = false;

      resumeResult.data = value;
      resumeResult.source = source!;

      onResume();
      return value!;
    });
  }

  /// Use instead of Navigator.pushNamed(), it fires onResume() after route popped
  Future<T> pushNamed<T extends Object>(BuildContext context, String routeName,
      {Object? arguments}) {
    _isPaused = true;
    onPause();

    return Navigator.of(context)
        .pushNamed<T>(routeName, arguments: arguments)
        .then((value) {
      _isPaused = false;

      resumeResult.data = value;
      resumeResult.source = routeName;

      onResume();
      return value!;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (!_isPaused) {
        onPause();
      }
    } else if (state == AppLifecycleState.resumed &&
        lastAppState == AppLifecycleState.paused) {
      if (!_isPaused) {
        onResume();
      }
    } else if (state == AppLifecycleState.detached) {
      onDetached();
    }
    lastAppState = state;
  }
}

class ResumeResult {
  dynamic data;
  late String source;
}
