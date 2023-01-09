import 'package:flutter/material.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/util/app_colors.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class StaySaltyTemplate extends StatefulWidget {
  final ConstructorBloc constructorBloc;

  StaySaltyTemplate({@required this.constructorBloc})
      : assert(constructorBloc != null);

  @override
  _StaySaltyTemplateState createState() => _StaySaltyTemplateState();
}

class _StaySaltyTemplateState extends State<StaySaltyTemplate> {
  DynamicTemplateEngine templateEngine;

  @override
  Widget build(BuildContext context) {
    templateEngine = Provider.of<DynamicTemplateEngine>(context);
    return Stack(
      children: <Widget>[
        buildBackground(),
        buildRectangle88(),
        buildRectangle89(),
        buildRectangle81(),
        build2Post(),
        build3Post(),
        buildRectangle84(),
        buildLeftBottom(),
        buildJustTop(),
        buildJustBottom(),
        buildLeftTop(),
        buildLine(),
        buildCenterBottom(),
        buildKeepTop(),
        buildFirstPost(),
        build4Post(),
        build5Post(),
        build6Post(),
        buildRightTopLeft(),
        buildRightBottomLeft(),
        buildRightTop(),
        buildSaltyTop(),
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
      color: AppColors.white,
    );
  }

  Widget buildRectangle88() {
    return Positioned(
      left: 0,
      top: 0,
      child: buildColorContainer(),
    );
  }

  Widget buildRectangle89() {
    return Positioned(
      left: templateEngine.getWidth(2808),
      top: 0,
      child: buildColorContainer(),
    );
  }

  Widget buildColorContainer() {
    return Container(
      width: templateEngine.getWidth(1620),
      height: templateEngine.getHeight(1080),
      color: Color(0xff0B3C49),
    );
  }

  Widget buildRectangle81() {
    return Positioned(
      left: templateEngine.getWidth(1296),
      top: templateEngine.getHeight(216),
      child: Container(
        width: templateEngine.getWidth(648),
        height: templateEngine.getHeight(648),
        color: Color(0xff037171),
      ),
    );
  }

  Widget buildRectangle84() {
    return Positioned(
      left: templateEngine.getWidth(3564),
      top: templateEngine.getHeight(701),
      child: Container(
        width: templateEngine.getWidth(432),
        height: templateEngine.getHeight(324),
        color: Color(0xff037171),
      ),
    );
  }

  Widget buildJustTop() {
    return EngineImage(
      width: 182,
      height: 189,
      pathToImage: 'assets/template_engine/stay_salty/just_top.png',
      top: 125,
      left: 1845,
    );
  }

  Widget buildLeftBottom() {
    return EngineImage(
      width: 254,
      height: 224,
      pathToImage: 'assets/template_engine/stay_salty/left_bottom.png',
      top: 842,
      left: 0,
    );
  }

  Widget buildJustBottom() {
    return EngineImage(
      width: 182,
      height: 189,
      pathToImage: 'assets/template_engine/stay_salty/just_bottom.png',
      top: 872,
      left: 1218,
    );
  }

  Widget buildLeftTop() {
    return EngineImage(
      width: 326,
      height: 340,
      pathToImage: 'assets/template_engine/stay_salty/left_top.png',
      top: 0,
      left: 917,
    );
  }

  Widget buildLine() {
    return Positioned(
      top: templateEngine.getHeight(108),
      left: templateEngine.getWidth(1728),
      child: Container(
        width: templateEngine.getWidth(540),
        height: templateEngine.getHeight(4),
        color: Colors.black,
      ),
    );
  }

  Widget buildRightTop() {
    return EngineImage(
      width: 290,
      height: 302,
      pathToImage: 'assets/template_engine/stay_salty/right_top.png',
      right: 0,
      top: 0,
    );
  }

  Widget buildRightTopLeft() {
    return EngineImage(
      width: 326,
      height: 215,
      pathToImage: 'assets/template_engine/stay_salty/right_top_left.png',
      left: 4158,
      top: 0,
    );
  }

  Widget buildSaltyTop() {
    return EngineImage(
      width: 182,
      height: 189,
      pathToImage: 'assets/template_engine/stay_salty/salty_top.png',
      left: 3598,
      top: 164,
    );
  }

  Widget buildCenterBottom() {
    return EngineImage(
      width: 182,
      height: 110,
      pathToImage: 'assets/template_engine/stay_salty/center_bottom.png',
      left: 2295,
      bottom: 0,
    );
  }

  Widget buildRightBottomLeft() {
    return EngineImage(
      width: 182,
      height: 189,
      pathToImage: 'assets/template_engine/stay_salty/right_bottom_left.png',
      left: 4221,
      top: 768,
    );
  }

  Widget buildKeepTop() {
    return EngineImage(
      width: 182,
      height: 189,
      pathToImage: 'assets/template_engine/stay_salty/keep_top.png',
      left: 3651,
      top: 608,
    );
  }

  Widget buildFirstPost() {
    return EnginePostChild(
      stackLeft: 324,
      stackTop: 108,
      plusPaddingTop: 320,
      plusPaddingLeft: 374,
      photoNumber: 0,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      photoHeight: 864,
      photoWidth: 972,
      angle: 0,
      plusSize: 83.12,
      whiteSize: 224,
      textRightPadding: 60,
      textBottomPadding: 40,
    );
  }

  Widget build2Post() {
    return EnginePostChild(
      stackLeft: 2376,
      stackTop: 162,
      plusPaddingTop: 347,
      plusPaddingLeft: 212,
      photoNumber: 1,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      photoHeight: 918,
      photoWidth: 648,
      angle: 0,
      plusSize: 83.12,
      whiteSize: 224,
      textRightPadding: 60,
      textBottomPadding: 1,
    );
  }

  Widget build3Post() {
    return EnginePostChild(
      stackLeft: 2808,
      stackTop: 386,
      plusPaddingTop: 168,
      plusPaddingLeft: 374,
      photoNumber: 2,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      photoHeight: 540,
      photoWidth: 972,
      angle: 0,
      plusSize: 83.12,
      whiteSize: 224,
      textRightPadding: 80,
      textBottomPadding: 329,
    );
  }

  Widget build4Post() {
    return EnginePostChild(
      stackLeft: 4212,
      stackTop: 107,
      plusPaddingTop: 128,
      plusPaddingLeft: 128,
      photoNumber: 3,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 90 : Constants.textSize22,
      photoHeight: 432,
      photoWidth: 432,
      angle: 0,
      plusSize: 65.31,
      whiteSize: 176,
      textRightPadding: 80,
      textBottomPadding: 289,
    );
  }

  Widget build5Post() {
    return EnginePostChild(
      stackLeft: 4320,
      stackTop: 431,
      plusPaddingTop: 128,
      plusPaddingLeft: 128,
      photoNumber: 4,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 90 : Constants.textSize22,
      photoHeight: 432,
      photoWidth: 432,
      angle: 0,
      plusSize: 65.31,
      whiteSize: 176,
      textRightPadding: 56,
      textBottomPadding: 40,
    );
  }

  Widget build6Post() {
    return EnginePostChild(
      stackLeft: 4860,
      stackTop: 56,
      plusPaddingTop: 374,
      plusPaddingLeft: 104,
      photoNumber: 5,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      photoHeight: 971,
      photoWidth: 432,
      angle: 0,
      plusSize: 83.12,
      whiteSize: 224,
      textRightPadding: 80,
      textBottomPadding: 56,
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
              top: 912,
              left: 264,
              photoHeight: templateEngine.getHeight(864),
              photoWidth: templateEngine.getWidth(972),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 0,
              top: 912,
              left: 1236,
              angle: 0,
              photoHeight: templateEngine.getHeight(864),
              photoWidth: templateEngine.getWidth(972),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 0,
              top: 48,
              left: 1236,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 1,
              top: 102,
              left: 2964,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 2,
              top: 866,
              left: 2748,
              photoHeight: templateEngine.getHeight(540),
              photoWidth: templateEngine.getWidth(972),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 2,
              top: 866,
              left: 3720,
              photoHeight: templateEngine.getHeight(540),
              photoWidth: templateEngine.getWidth(972),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 2,
              top: 326,
              left: 3720,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 3,
              top: 480,
              left: 4152,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(432),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 3,
              top: 479,
              left: 4581,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(432),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 3,
              top: 44,
              left: 4584,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 4,
              top: 803,
              left: 4260,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(432),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 4,
              top: 803,
              left: 4692,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(432),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 4,
              top: 371,
              left: 4692,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 5,
              top: 967,
              left: 4800,
              photoHeight: templateEngine.getHeight(971),
              photoWidth: templateEngine.getWidth(432),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 5,
              top: 967,
              left: 5232,
              photoHeight: templateEngine.getHeight(971),
              photoWidth: templateEngine.getWidth(432),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 5,
              top: 4,
              left: 5232,
            ),
          ],
        ),
      ),
    );
  }
}
