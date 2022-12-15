import 'package:flutter/material.dart';

class BottomGradient extends StatelessWidget {
  final double offset;
  BorderRadius? borderRadius = const BorderRadius.all(Radius.zero);
  Color? colorEnd = const Color(0xFF181B2D);

  BottomGradient({this.offset: 0.95, this.borderRadius, this.colorEnd});

  BottomGradient.noOffset() : offset = 1.0; //hàm noOffset() => max value = 1.0

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              //phần bù giống với Alignment
              end: FractionalOffset(0.0, 0.0),
              begin: FractionalOffset(0.0, offset),

              colors: <Color>[colorEnd ?? const Color(0xDAEFEEEE), const Color(
                  0x44D9D9D9), const Color(0x002C2B33)],
            )));
  }
}
