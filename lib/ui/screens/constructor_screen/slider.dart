import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class CustomSlider extends StatefulWidget {
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Template template = Provider.of<Template>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constants.width24),
      child: Row(
        children: <Widget>[
          Spacer(flex: 1),
          Stack(
            children: <Widget>[
              Container(
                width: template.sliderWidth,
                height: template.sliderHeight,
                child: Image.asset(
                  template.sliderFilePath,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 0,
                left: template.sliderHeight / 2 + Constants.height1,
                right: template.sliderHeight / 2,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackShape: RetroSliderTrackShape(),
                    trackHeight: template.sliderHeight,
                    activeTrackColor: AppColors.pink,
                    overlayColor: Colors.transparent,
                    thumbShape: RetroSliderThumbShape(template.sliderHeight),
                  ),
                  child: StreamBuilder<SliderData>(
                    stream: Provider.of<ConstructorBloc>(context).getSliderPosition,
                    initialData: SliderData(
                      scrollPositions: 0.0,
                      maxScrollPosition: template.templateWidth.toDouble(),
                    ),
                    builder: (context, snapshot) {
                      double value = snapshot.data.scrollPositions;
                      double maxScrollPositions = snapshot.data.maxScrollPosition;
                      if (value > maxScrollPositions) value = maxScrollPositions;
                      return Slider(
                        value: value,
                        onChanged: (value) {
                          Provider.of<ScrollController>(context, listen: false).jumpTo(value);
                          Provider.of<ConstructorBloc>(context, listen: false).updateSlider(value);
                        },
                        min: 0,
                        max: maxScrollPositions,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Spacer(flex: 1)
        ],
      ),
    );
  }
}

class RetroSliderTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData sliderTheme,
    bool isEnabled,
    bool isDiscrete,
  }) {
    final double thumbWidth = sliderTheme.thumbShape.getPreferredSize(true, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    assert(thumbWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= thumbWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx;
    final double trackTop = offset.dy; // + (parentBox.size.height) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    Animation<double> enableAnimation,
    TextDirection textDirection,
    Offset thumbCenter,
    bool isDiscrete,
    bool isEnabled,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint fillPaint = Paint()..color = (Colors.transparent);

    final pathSegment = Path()
      ..moveTo(trackRect.left, trackRect.top)
      ..lineTo(trackRect.right, trackRect.top)
      ..lineTo(trackRect.right, trackRect.bottom)
      ..lineTo(trackRect.left, trackRect.bottom);

    context.canvas.drawPath(pathSegment, fillPaint);
  }
}

class RetroSliderThumbShape extends SliderComponentShape {
  final double width;

  RetroSliderThumbShape(this.width);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.square(width * Constants.height1);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCenter(center: center, height: width, width: width);

    final fillPaint = Paint()
      ..color = sliderTheme.activeTrackColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(rect, fillPaint);
  }
}
