import 'package:flutter/material.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class BlackFamousTemplate extends StatefulWidget {
  final ConstructorBloc constructorBloc;

  BlackFamousTemplate({@required this.constructorBloc})
      : assert(constructorBloc != null);

  @override
  _BlackFamousTemplateState createState() => _BlackFamousTemplateState();
}

class _BlackFamousTemplateState extends State<BlackFamousTemplate> {
  DynamicTemplateEngine templateEngine;

  @override
  Widget build(BuildContext context) {
    templateEngine = Provider.of<DynamicTemplateEngine>(context);
    return Stack(
      children: <Widget>[
        buildBackground(),
        buildColorContainerLeft(),
        buildBottomLeft(),
        buildBottomLeft2(),
        buildBottomRight(),
        buildCenterRight(),
        buildTopLeft(),
        buildTopLeft2(),
        build5Post(),
        buildTopCenter(),
        buildTopRight2(),
        buildTopRight(),
        build1Post(),
        buildLine1(),
        buildLine2(),
        buildLine3(),
        build2Post(),
        build3Post(),
        build4Post(),
        build6Post(),
        buildColorContainerRight(),
        for (int i = 0; i < Provider.of<List<FieldItem>>(context).length; i++)
          DraggableTextField(
            fieldItem: Provider.of<List<FieldItem>>(context)[i],
            index: i,
            constructorBloc: Provider.of<ConstructorBloc>(context),
            isPreview: Provider.of<bool>(context),
            templateContext: context,
          ),
        if (!Provider.of<bool>(context)) buildActionButtons(),
      ],
    );
  }

  Widget buildBackground() {
    return Container(
      height: templateEngine.getMainHeight,
      width: templateEngine.getMainWidth,
      color: Colors.black,
    );
  }

  Widget buildColorContainerLeft() {
    return Positioned(
      top: templateEngine.getHeight(162),
      left: templateEngine.getHeight(108),
      child: Container(
        width: templateEngine.getHeight(648),
        height: templateEngine.getHeight(756),
        color: Color(0xffF7B2BD),
      ),
    );
  }

  Widget buildColorContainerRight() {
    return Positioned(
      top: templateEngine.getHeight(324),
      left: templateEngine.getHeight(4266),
      child: Container(
        width: templateEngine.getHeight(324),
        height: templateEngine.getHeight(432),
        color: Color(0xffF7B2BD),
      ),
    );
  }

  Widget buildLine1() {
    return Positioned(
      top: templateEngine.getHeight(270),
      left: templateEngine.getHeight(162),
      child: Container(
        width: templateEngine.getHeight(270),
        height: templateEngine.getHeight(3),
        color: Color(0xffE34A6F),
      ),
    );
  }

  Widget buildLine2() {
    return Positioned(
      top: templateEngine.getHeight(270),
      left: templateEngine.getHeight(162),
      child: Container(
        width: templateEngine.getHeight(3),
        height: templateEngine.getHeight(486),
        color: Color(0xffE34A6F),
      ),
    );
  }

  Widget buildLine3() {
    return Positioned(
      top: templateEngine.getHeight(756),
      left: templateEngine.getHeight(162),
      child: Container(
        width: templateEngine.getHeight(270),
        height: templateEngine.getHeight(3),
        color: Color(0xffE34A6F),
      ),
    );
  }

  Widget buildBottomLeft() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/bottom_left.png',
      height: 266,
      width: 215,
      left: 0,
      bottom: 0,
    );
  }

  Widget buildBottomLeft2() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/bottom_left_2.png',
      height: 235,
      width: 398,
      left: 931,
      bottom: 0,
    );
  }

  Widget buildBottomRight() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/bottom_right.png',
      height: 297,
      width: 398,
      left: 3944,
      bottom: 0,
    );
  }

  Widget buildCenterRight() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/center_right.png',
      height: 408,
      width: 398,
      left: 5018,
      top: 560,
    );
  }

  Widget buildTopLeft() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/top_left.png',
      height: 168,
      width: 303,
      left: 183,
      top: 0,
    );
  }

  Widget buildTopLeft2() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/top_left_2.png',
      height: 360,
      width: 364,
      left: 1015,
      top: 16,
    );
  }

  Widget buildTopCenter() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/top_center.png',
      height: 340,
      width: 326,
      left: 2397,
      top: 0,
    );
  }

  Widget buildTopRight2() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/top_right_2.png',
      height: 297,
      width: 303,
      left: 3675,
      top: 0,
    );
  }

  Widget buildTopRight() {
    return EngineImage(
      pathToImage: 'assets/template_engine/black_famous/top_right.png',
      height: 201,
      width: 235,
      right: 0,
      top: 0,
    );
  }

  Widget build1Post() {
    return EnginePostChild(
      photoWidth: 648,
      photoHeight: 756,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      photoNumber: 0,
      plusPaddingTop: 266,
      plusPaddingLeft: 212,
      textBottomPadding: 56,
      textRightPadding: 80,
      whiteSize: 224,
      plusSize: 83,
      stackTop: 108,
      stackLeft: 324,
    );
  }

  Widget build2Post() {
    return EnginePostChild(
      photoWidth: 378,
      photoHeight: 378,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 90 : Constants.textSize22,
      photoNumber: 1,
      plusPaddingTop: 101,
      plusPaddingLeft: 101,
      textBottomPadding: 24,
      textRightPadding: 32,
      whiteSize: 176,
      plusSize: 65,
      stackTop: 162,
      stackLeft: 1242,
    );
  }

  Widget build3Post() {
    return EnginePostChild(
      photoWidth: 378,
      photoHeight: 378,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 90 : Constants.textSize22,
      photoNumber: 2,
      plusPaddingTop: 101,
      plusPaddingLeft: 101,
      textBottomPadding: 24,
      textRightPadding: 32,
      whiteSize: 176,
      plusSize: 65,
      stackTop: 540,
      stackLeft: 1620,
    );
  }

  Widget build4Post() {
    return EnginePostChild(
      photoWidth: 378,
      photoHeight: 378,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 90 : Constants.textSize22,
      photoNumber: 3,
      plusPaddingTop: 101,
      plusPaddingLeft: 101,
      textBottomPadding: 24,
      textRightPadding: 32,
      whiteSize: 176,
      plusSize: 65,
      stackTop: 162,
      stackLeft: 1998,
    );
  }

  Widget build5Post() {
    return EnginePostChild(
      photoWidth: 1350,
      photoHeight: 1080,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      photoNumber: 4,
      plusPaddingTop: 428,
      plusPaddingLeft: 563,
      textBottomPadding: 80,
      textRightPadding: 80,
      whiteSize: 224,
      plusSize: 83,
      stackTop: 0,
      stackLeft: 2626,
    );
  }

  Widget build6Post() {
    return EnginePostChild(
      photoWidth: 702,
      photoHeight: 702,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 90 : Constants.textSize22,
      photoNumber: 5,
      plusPaddingTop: 263,
      plusPaddingLeft: 263,
      textBottomPadding: 32,
      textRightPadding: 56,
      whiteSize: 176,
      plusSize: 65,
      stackTop: 189,
      stackLeft: 4482,
    );
  }

  Widget buildActionButtons() {
    return Container(
      width: templateEngine.getMainWidth,
      height: templateEngine.getMainHeight,
      child: Provider.value(
        value: 120.0,
        child: Stack(
          children: <Widget>[
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 0,
              top: 804,
              left: 264,
              photoHeight: templateEngine.getHeight(756),
              photoWidth: templateEngine.getWidth(648),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 0,
              top: 804,
              left: 912,
              angle: 0,
              photoHeight: templateEngine.getHeight(756),
              photoWidth: templateEngine.getWidth(648),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 0,
              top: 48,
              left: 912,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 1,
              top: 480,
              left: 1182,
              photoHeight: templateEngine.getHeight(378),
              photoWidth: templateEngine.getWidth(378),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 1,
              top: 480,
              left: 1560,
              angle: 0,
              photoHeight: templateEngine.getHeight(378),
              photoWidth: templateEngine.getWidth(378),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 1,
              top: 102,
              left: 1560,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 2,
              top: 858,
              left: 1560,
              photoHeight: templateEngine.getHeight(378),
              photoWidth: templateEngine.getWidth(378),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 2,
              top: 858,
              left: 1938,
              photoHeight: templateEngine.getHeight(378),
              photoWidth: templateEngine.getWidth(378),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 2,
              top: 480,
              left: 1938,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 3,
              top: 480,
              left: 1938,
              photoHeight: templateEngine.getHeight(378),
              photoWidth: templateEngine.getWidth(378),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 3,
              top: 480,
              left: 2316,
              photoHeight: templateEngine.getHeight(378),
              photoWidth: templateEngine.getWidth(378),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 3,
              top: 102,
              left: 2316,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 5,
              top: 830,
              left: 4426,
              photoHeight: templateEngine.getHeight(702),
              photoWidth: templateEngine.getWidth(702),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 5,
              top: 831,
              left: 5124,
              photoHeight: templateEngine.getHeight(702),
              photoWidth: templateEngine.getWidth(702),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 5,
              top: 129,
              left: 5125,
            ),
          ],
        ),
      ),
    );
  }
}
