import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../di/injection.dart';

/// normal click event
abstract class Presenter {
  void onClick(String action);
}

/// ListView Item Click
abstract class ItemPresenter<T> {
  void onItemClick(String action, T item);
}

/// BaseViewModel
class BaseViewModel with ChangeNotifier {
  CompositeSubscription compositeSubscription = CompositeSubscription();

  /// add [StreamSubscription] to [compositeSubscription]
  addSubscription(StreamSubscription subscription) {
    compositeSubscription.add(subscription);
  }

  @override
  void dispose() {
    if (!compositeSubscription.isDisposed) {
      compositeSubscription.dispose();
    }
    super.dispose();
  }
}

abstract class PageProvideNode<T extends ChangeNotifier> extends StatelessWidget
    implements Presenter {
  final T viewModel;

  PageProvideNode({List<dynamic>? params, Key? key})
      : viewModel = getIt<T>(param1: params),
        super(key: key);

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: buildContent(context),
    );
  }

  @override
  void onClick(String action) {}
}
