import 'package:flutter/material.dart';
import 'dart:math';

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    Key? key,
    required this.tag,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  final String tag;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${Random().nextInt(1000)}' + tag + 'PhotoHero',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
