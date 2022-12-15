import 'package:flutter/material.dart';

import '../../../module/res/colors.dart';

class PulseWidget extends StatefulWidget {
  final Widget? child;
  final AnimationController? controller;

  const PulseWidget({Key? key, this.child, this.controller}) : super(key: key);

  @override
  PulseWidgetState createState() => PulseWidgetState();
}

class PulseWidgetState extends State<PulseWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 2),
    )..repeat();
  }
  
  void play() {
    _controller.repeat();
  }
  
  void stop() {
    _controller.stop();
    _controller.reset();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
      builder: (context, child) {
        return Visibility(
          visible: _controller.isAnimating,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildContainer(30 * _controller.value),
              _buildContainer(60 * _controller.value),
              _buildContainer(75 * _controller.value),
              _buildContainer(100 * _controller.value),
              _buildContainer(105 * _controller.value),
              if (widget.child != null) Align(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kColorPrimary.withOpacity(1 - _controller.value),
      ),
    );
  }
}
