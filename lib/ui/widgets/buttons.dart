import 'package:flutter/material.dart';
import 'package:instapanoflutter/util/util.dart';

class ButtonRectangle34 extends StatelessWidget {
  final Function() onPressed;
  final double width;
  final String text;
  final String heroTag;

  ButtonRectangle34(
      {@required this.onPressed,
      @required this.width,
      @required this.text,
      this.heroTag})
      : assert(onPressed != null),
        assert(width != null),
        assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: Constants.height52,
      decoration: BoxDecoration(
        borderRadius: Constants.buttonBorderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xfffdc4de),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: AppColors.pink,
        shape: Constants.defaultButtonShape,
        heroTag: heroTag ?? 'next',
        elevation: 0,
        highlightElevation: 0,
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTypography.buttonText,
        ),
      ),
    );
  }
}

class ButtonRectangle12 extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;
  final String timeText;
  final String fullPrice;
  final String heroTag;
  final String perMonthPrice;
  final Cubic curve;
  final Duration duration;

  ButtonRectangle12(
      {@required this.onPressed,
      @required this.fullPrice,
      @required this.isActive,
      @required this.perMonthPrice,
      @required this.timeText,
      this.heroTag,
      this.curve,
      this.duration})
      : assert(onPressed != null),
        assert(fullPrice != null),
        assert(isActive != null),
        assert(perMonthPrice != null),
        assert(timeText != null);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: Constants.width343,
      height: Constants.height67,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: Constants.buttonBorderRadius,
        gradient: isActive
            ? LinearGradient(colors: [
                Color(0xffFF3763),
                Color(0xffFF4FA8),
              ], stops: [
                0.35,
                1
              ], begin: Alignment.centerLeft, end: Alignment.centerRight)
            : LinearGradient(colors: [
                AppColors.black.withOpacity(0.5),
                AppColors.black.withOpacity(0.5),
              ], stops: [
                0.35,
                1
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      ),
      child: FloatingActionButton(
        elevation: 0,
        highlightElevation: 0,
        heroTag: heroTag ?? 'tag',
        shape: Constants.defaultButtonShape,
        backgroundColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Constants.width32, vertical: Constants.height11_5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    timeText,
                    style: AppTypography.timeText
                        .copyWith(fontSize: Constants.textSize17),
                  ),
                  Text(
                    'Full Price \$$fullPrice',
                    style: AppTypography.price.copyWith(
                      fontSize: Constants.textSize14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '\$ $perMonthPrice /',
                    style: AppTypography.price.copyWith(
                      fontSize: Constants.textSize14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Per month',
                    style: AppTypography.price.copyWith(
                      fontSize: Constants.textSize14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListButton extends StatefulWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final List<Color> gradientColors;
  final boxShadowColor;
  final double width;

  ListButton({
    @required this.text,
    this.color,
    @required this.boxShadowColor,
    @required this.onPressed,
    this.gradientColors,
    @required this.width,
  })  : assert(text != null),
        assert(width != null),
        assert(onPressed != null),
        assert(boxShadowColor != null);

  @override
  _ListButtonState createState() => _ListButtonState();
}

class _ListButtonState extends State<ListButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: Constants.height27,
      decoration: BoxDecoration(
        color: widget.color ?? null,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        gradient: widget.gradientColors != null
            ? LinearGradient(colors: [
                widget.gradientColors[0],
                widget.gradientColors[1],
              ], begin: Alignment.centerLeft, end: Alignment.centerRight)
            : null,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: widget.boxShadowColor,
              offset: Offset(0, 6),
              blurRadius: Constants.height8)
        ],
      ),
      child: FloatingActionButton(
        elevation: 0,
        highlightElevation: 0,
        heroTag: widget.text,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        backgroundColor: Colors.transparent,
        onPressed: widget.onPressed,
        child: Text(
          widget.text,
          style: AppTypography.listScroll,
        ),
      ),
    );
  }
}

class ButtonRectangle20 extends StatelessWidget {
  final Function() onPressed;
  final double height;
  final double width;
  final Widget child;
  final bool onCenter;

  ButtonRectangle20({
    Key key,

    /// По дефолту это кнопка с [child] по центру, для иного ставить false
    this.onCenter = true,
    this.onPressed,
    @required this.child,
    @required this.height,
    @required this.width,
  })  : assert(child != null),
        assert(width != null),
        assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: Colors.white,
        border: Border.all(color: Color(0xffe0e0e0), width: 0.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xffe0e0e0),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: onCenter
            ? Center(
                child: child,
              )
            : child,
      ),
    );
  }
}

enum Orientation { VERTICAL, HORIZONTAL, FULL }

class Rectangle32 extends StatelessWidget {
  final Orientation orientation;
  final bool isActive;

  Rectangle32({
    this.isActive = false,
    @required this.orientation,
  }) : assert(orientation != null);

  @override
  Widget build(BuildContext context) {
    double height = 0;
    double width = 0;
    switch (orientation) {
      case Orientation.VERTICAL:
        {
          height = Constants.height36;
          width = Constants.width26;
          break;
        }
      case Orientation.HORIZONTAL:
        {
          height = Constants.height26;
          width = Constants.width42;
          break;
        }
      case Orientation.FULL:
        {
          height = Constants.height36;
          width = Constants.width36;
        }
    }
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: Colors.white,
        border: Border.all(
            color: isActive ? AppColors.pink : AppColors.black, width: 1),
      ),
    );
  }
}

class Rectangle203 extends StatelessWidget {
  final Function onTap;
  final String text;
  final double width;
  final bool isActive;

  Rectangle203({
    @required this.width,
    @required this.onTap,
    @required this.text,
    @required this.isActive,
  })  : assert(width != null),
        assert(onTap != null),
        assert(text != null),
        assert(isActive != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: Constants.height36,
      decoration: isActive
          ? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: AppColors.pink, width: 1),
            )
          : null,
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: AppTypography.subhead.copyWith(
              color: isActive ? AppColors.pink : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
