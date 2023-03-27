import 'package:flutter/material.dart';

class OptionalBadge extends StatelessWidget {
  final double scaling;
  const OptionalBadge({Key? key, this.scaling = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      padding: EdgeInsets.only(
        left: 6 * scaling,
        right: 6 * scaling,
        top: 3 * scaling,
        bottom: 2 * scaling,
      ),
      child: Text(
        '報告',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12 * scaling,
          height: 1,
        ),
      ),
    );
  }
}
