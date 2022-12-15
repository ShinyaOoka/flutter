import 'package:flutter/material.dart';

class OnBoardingAnimationWidget extends StatefulWidget {
  final int initialStep;
  String url = '';

  OnBoardingAnimationWidget({
    Key? key,
    this.initialStep = 0,
    required this.url,
  }) : super(key: key);

  @override
  OnBoardingAnimationWidgetState createState() =>
      OnBoardingAnimationWidgetState();
}

class OnBoardingAnimationWidgetState extends State<OnBoardingAnimationWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _animationsStep = [
    70 / 866,
    560 / 866,
    670 / 866,
    740 / 866,
    850 / 866,
    866 / 866
  ];

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.value =
        widget.initialStep == 0 ? 0 : _animationsStep[widget.initialStep - 1];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: /*Lottie.asset(
        'assets/animations/onboarding/data.json',
        fit: BoxFit.fitWidth,
        controller: _controller,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          _controller.animateTo(_animationsStep[widget.initialStep]);
        },
      ),*/
      Image.asset(widget.url,
        fit: BoxFit.fitWidth,)
    );
  }

  bool get isAnimating => _controller.isAnimating;

  void animateStep(int step) {
    _controller.value = step == 0 ? 0 : _animationsStep[step - 1];
    _controller.animateTo(
      _animationsStep[step],
      duration: Duration(milliseconds: 300),
    );
  }

  void reset() {
    _controller.animateTo(_animationsStep[5]);
    animateStep(0);
  }

  @override
  bool get wantKeepAlive => true;
}
