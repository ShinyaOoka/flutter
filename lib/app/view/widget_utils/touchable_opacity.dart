import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*Ripple Button*/
class TouchableOpacity extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  TouchableOpacity({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: child,
    );
  }
}
