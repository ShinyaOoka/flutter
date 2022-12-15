import 'package:flutter/material.dart';

class AnimatedInWidget extends StatefulWidget {
  final Widget child;
  final int order;
  final bool animated;

  const AnimatedInWidget({
    Key? key,
    required this.child,
    this.order = 0,
    this.animated = true,
  }) : super(key: key);

  @override
  _AnimatedInWidgetState createState() => _AnimatedInWidgetState();
}

class _AnimatedInWidgetState extends State<AnimatedInWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.animated ? 0 : 1,
      duration: Duration(milliseconds: 200),
    );
    _animation = Tween(begin: 30.0, end: 0.0).animate(_controller);
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    if (widget.animated) {
      Future.delayed(Duration(milliseconds: 100 * widget.order), () {
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _animation.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}
