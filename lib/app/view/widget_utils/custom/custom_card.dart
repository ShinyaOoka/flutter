import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Function? onPressed;
  final Brightness rippleBrightness;
  final double borderRadiusValue;
  final Color backgroundColor;
  final Gradient? backgroundGradient;
  final Shadow shadow;
  final BoxBorder? boxBorder;
  final Clip? clipBehavior;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding,
    this.onPressed,
      this.rippleBrightness = Brightness.light,
    this.borderRadiusValue = 8.0,
    this.backgroundColor = Colors.white,
    this.backgroundGradient,
    this.shadow = Shadow.normal,
    this.boxBorder,
    this.margin,
    this.clipBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior ?? Clip.none,
      margin: margin ?? const EdgeInsets.all(0.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: backgroundGradient ?? null,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          boxShadow: _getShadows(),
          border: boxBorder,
        ),
        // clip corners
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          child: Stack(
            children: <Widget>[
              Container(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),

              // Flat button on top if onPressed provided
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                left: 0,
                child: onPressed == null
                    ? SizedBox()
                    : MaterialButton(
                        colorBrightness: rippleBrightness,
                        onPressed: () => onPressed,
                        child: SizedBox(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _getShadows() {
    switch (shadow) {
      case Shadow.normal:
        return [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 15,
            color: Colors.black12,
          )
        ];
        break;
      case Shadow.large:
        return [
          BoxShadow(
            offset: Offset(0, 15),
            blurRadius: 35,
            color: Color(0x12000000),
          )
        ];
        break;
      case Shadow.soft:
        return [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 15,
            color: Color(0x12000000),
          )
        ];
        break;
      case Shadow.none:
        return [];
        break;
    }

    return [];
  }
}

enum Shadow { normal, large, soft, none }
