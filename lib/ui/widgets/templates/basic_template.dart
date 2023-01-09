import 'package:flutter/material.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class BasicTemplateWidget extends StatefulWidget {
  @override
  _BasicTemplateWidgetState createState() => _BasicTemplateWidgetState();
}

class _BasicTemplateWidgetState extends State<BasicTemplateWidget> {
  DynamicTemplateEngine templateEngine;

  @override
  Widget build(BuildContext context) {
    templateEngine = Provider.of<DynamicTemplateEngine>(context);
    return Stack(
      children: <Widget>[
        buildRectangle1(),
        buildRectangle2(),
        buildRectangle4(),
        buildRectangle5(),
        buildRectangle6(),
        buildRectangle7(),
        buildRectangle31(),
        buildRectangle24(),
        buildSecondPost1(),
        buildSecondPost2(),
        buildSecondPost3(),
        buildSecondPost4(),
        buildRectangle3(),
        buildRectangle20(),
        buildRectangle22(),
        buildRectangle23(),
        buildRectangle12(),
        buildFirstPost(),
        buildRectangle18(),
        buildRectangle21(),
        buildFourthPost(),
        buildRectangle32(),
        buildRectangle26_1(),
        buildThirdPost2(),
        buildRectangle26(),
        buildThirdPost1(),
        buildRectangle29(),
        buildRectangle30(),
        if (!Provider.of<bool>(context)) buildActionButtons(),
        for (int i = 0; i < Provider.of<List<FieldItem>>(context).length; i++)
          DraggableTextField(
            fieldItem: Provider.of<List<FieldItem>>(context)[i],
            index: i,
            constructorBloc: Provider.of<ConstructorBloc>(context),
            isPreview: Provider.of<bool>(context),
            templateContext: context,
          ),
      ],
    );
  }

  Widget buildRectangle1() {
    return Container(
      height: templateEngine.getMainHeight,
      width: templateEngine.getMainWidth,
      child: Image.asset(
        'assets/template_engine/basic_template/rectangle1.png',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildRectangle2() {
    return EngineImage(
      top: 0,
      left: 556,
      height: 1080,
      width: 1000,
      pathToImage: 'assets/template_engine/basic_template/rectangle2.png',
    );
  }

  Widget buildRectangle3() {
    return EngineImage(
      top: 0,
      left: 0,
      height: 364.13,
      width: 1350,
      pathToImage: 'assets/template_engine/basic_template/rectangle3.png',
    );
  }

  Widget buildRectangle4() {
    return EngineImage(
      bottom: 0,
      right: 0,
      height: 562,
      width: 1893,
      pathToImage: 'assets/template_engine/basic_template/rectangle4.png',
    );
  }

  Widget buildRectangle5() {
    return EngineImage(
      bottom: 0,
      right: 320,
      height: 372,
      width: 1757,
      pathToImage: 'assets/template_engine/basic_template/rectangle5.png',
    );
  }

  Widget buildRectangle6() {
    return EngineImage(
      top: 0,
      left: 0,
      height: 708,
      width: 1582,
      pathToImage: 'assets/template_engine/basic_template/rectangle6.png',
    );
  }

  Widget buildRectangle7() {
    return EngineImage(
      top: 0,
      right: 0,
      height: 364,
      width: 990,
      pathToImage: 'assets/template_engine/basic_template/rectangle7.png',
    );
  }

  Widget buildRectangle12() {
    return EngineImage(
      left: 50,
      top: 131,
      width: 941,
      height: 949,
      pathToImage: 'assets/template_engine/basic_template/rectangle12.png',
    );
  }

  Widget buildRectangle18() {
    return EngineImage(
      height: 500,
      width: 362,
      top: 0,
      left: 0,
      pathToImage: 'assets/template_engine/basic_template/rectangle18.png',
    );
  }

  Widget buildRectangle20() {
    return EngineImage(
      height: 148.72,
      width: 200.2,
      left: 1070,
      bottom: 30.24,
      pathToImage: 'assets/template_engine/basic_template/rectangle20.png',
    );
  }

  Widget buildRectangle21() {
    return EngineImage(
      height: 156.56,
      width: 170,
      top: 35,
      left: 1114,
      pathToImage: 'assets/template_engine/basic_template/rectangle21.png',
    );
  }

  Widget buildRectangle22() {
    return EngineImage(
      height: 128.37,
      width: 172.8,
      left: 1935,
      top: 20,
      pathToImage: 'assets/template_engine/basic_template/rectangle22.png',
    );
  }

  Widget buildRectangle23() {
    return EngineImage(
      height: 167.2,
      width: 225.08,
      left: 1918,
      bottom: 16.27,
      pathToImage: 'assets/template_engine/basic_template/rectangle23.png',
    );
  }

  Widget buildRectangle24() {
    return EngineImage(
      height: 716,
      width: 1101,
      left: 1283,
      bottom: 0,
      pathToImage: 'assets/template_engine/basic_template/rectangle24.png',
    );
  }

  Widget buildRectangle26() {
    return EngineImage(
      height: 863,
      width: 667,
      left: 2359,
      top: 119,
      rotate: 4,
      pathToImage: 'assets/template_engine/basic_template/rectangle26.png',
    );
  }

  Widget buildRectangle26_1() {
    return EngineImage(
      height: 830,
      width: 800,
      right: 954,
      bottom: 0,
      pathToImage: 'assets/template_engine/basic_template/rectangle26_1.png',
    );
  }

  Widget buildRectangle29() {
    return EngineImage(
      height: 214.43,
      width: 288.66,
      bottom: 85.45,
      right: 684.16,
      pathToImage: 'assets/template_engine/basic_template/rectangle29.png',
    );
  }

  Widget buildRectangle30() {
    return EngineImage(
      height: 214.43,
      width: 288.66,
      top: 10,
      right: 0,
      pathToImage: 'assets/template_engine/basic_template/rectangle30.png',
    );
  }

  Widget buildRectangle31() {
    return EngineImage(
      right: 446.79,
      top: 0,
      width: 1398.21,
      height: 752.17,
      pathToImage: 'assets/template_engine/basic_template/rectangle31.png',
    );
  }

  Widget buildRectangle32() {
    return EngineImage(
      height: 392,
      width: 616,
      bottom: 0,
      right: 0,
      pathToImage: 'assets/template_engine/basic_template/rectangle32.png',
    );
  }

  Widget buildFirstPost() {
    return EnginePostChild(
      stackTop: 286,
      stackLeft: 197,
      photoHeight: 646.24,
      photoWidth: 607.67,
      photoNumber: 0,
      angle: -14.5,
      plusPaddingTop: 250,
      plusPaddingLeft: 220,
      textRightPadding: 50.31,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
    );
  }

  Widget buildSecondPost1() {
    int photoIndex = 1;
    return TransparentEnginePost(
      height: 432,
      width: 427,
      top: 85,
      left: 1155,
      child: TransparentEnginePostChild(
        photoHeight: 432,
        photoWidth: 427,
        photoNumber: photoIndex,
        plusPaddingTop: 90,
        plusPaddingLeft: 100,
        textSize: Provider.of<Key>(context) == Key('save')
            ? 90
            : Constants.textSize22,
      ),
    );
  }

  Widget buildSecondPost2() {
    int photoIndex = 2;
    return TransparentEnginePost(
      height: 432,
      width: 427,
      top: 85,
      left: 1620,
      child: TransparentEnginePostChild(
        photoHeight: 432,
        photoWidth: 427,
        photoNumber: photoIndex,
        plusPaddingTop: 90,
        plusPaddingLeft: 100,
        textSize: Provider.of<Key>(context) == Key('save')
            ? 90
            : Constants.textSize22,
      ),
    );
  }

  Widget buildSecondPost3() {
    int photoIndex = 3;
    return TransparentEnginePost(
      height: 432,
      width: 427,
      top: 566,
      left: 1155,
      child: TransparentEnginePostChild(
        photoHeight: 432,
        photoWidth: 427,
        photoNumber: photoIndex,
        plusPaddingTop: 90,
        plusPaddingLeft: 100,
        textSize: Provider.of<Key>(context) == Key('save')
            ? 90
            : Constants.textSize22,
      ),
    );
  }

  Widget buildSecondPost4() {
    int photoIndex = 4;
    return TransparentEnginePost(
      height: 432,
      width: 427,
      top: 566,
      left: 1620,
      child: TransparentEnginePostChild(
        photoHeight: 432,
        photoWidth: 427,
        photoNumber: photoIndex,
        plusPaddingTop: 90,
        plusPaddingLeft: 100,
        textSize: Provider.of<Key>(context) == Key('save')
            ? 90
            : Constants.textSize22,
      ),
    );
  }

  Widget buildThirdPost1() {
    return EnginePostChild(
      stackTop: 189,
      stackLeft: 2416,
      photoHeight: 592.95,
      photoWidth: 557.56,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      plusPaddingTop: 190,
      plusPaddingLeft: 200,
      photoNumber: 5,
      textRightPadding: 45,
      angle: 4,
    );
  }

  Widget buildThirdPost2() {
    return EnginePostChild(
      stackTop: 355,
      stackLeft: 2685,
      photoHeight: 592.95,
      photoWidth: 557.56,
      textSize:
          Provider.of<Key>(context) == Key('save') ? 130 : Constants.textSize32,
      plusPaddingTop: 20,
      plusPaddingLeft: 350,
      photoNumber: 6,
      textRightPadding: 15,
      angle: 11.5,
    );
  }

  Widget buildFourthPost() {
    int photoIndex = 7;
    return TransparentEnginePost(
      height: 842,
      width: 786,
      top: 79,
      right: 59,
      child: TransparentEnginePostChild(
        photoHeight: 842,
        photoWidth: 786,
        textSize: Provider.of<Key>(context) == Key('save')
            ? 130
            : Constants.textSize32,
        photoNumber: photoIndex,
        plusPaddingTop: 310,
        plusPaddingLeft: 260,
        textRightPadding: 5,
        whiteSize: 224,
        plusSize: 83.15,
      ),
    );
  }

  Widget buildActionButtons() {
    return Container(
      width: templateEngine.getMainWidth,
      height: templateEngine.getMainHeight,
      child: Provider.value(
        value: 96.0,
        child: Stack(
          children: <Widget>[
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 0,
              top: 960,
              left: 240,
              photoHeight: templateEngine.getHeight(646.24),
              photoWidth: templateEngine.getWidth(607.67),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 0,
              top: 790,
              left: 830,
              angle: -15,
              photoHeight: templateEngine.getHeight(646.24),
              photoWidth: templateEngine.getWidth(607.67),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 0,
              top: 165,
              left: 655,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 1,
              top: 451,
              left: 1115,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 1,
              top: 451,
              left: 1516,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 1,
              top: 55,
              left: 1516,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 2,
              top: 451,
              left: 1575,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 2,
              top: 451,
              left: 1996,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 2,
              top: 55,
              left: 1981,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 3,
              top: 932,
              left: 1115,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 3,
              top: 932,
              left: 1516,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 3,
              top: 536,
              left: 1516,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 4,
              top: 932,
              left: 1590,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 4,
              top: 932,
              left: 1981,
              photoHeight: templateEngine.getHeight(432),
              photoWidth: templateEngine.getWidth(427),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 4,
              top: 536,
              left: 1981,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 5,
              top: 716,
              left: 2349,
              photoHeight: templateEngine.getHeight(592.95),
              photoWidth: templateEngine.getWidth(557.56),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 5,
              top: 753,
              left: 2904,
              photoHeight: templateEngine.getHeight(592.95),
              photoWidth: templateEngine.getWidth(557.56),
              angle: 0.0698132,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 5,
              top: 163,
              left: 2946,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 6,
              top: 839,
              left: 2574,
              photoHeight: templateEngine.getHeight(592.95),
              photoWidth: templateEngine.getWidth(557.56),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 6,
              top: 950,
              left: 3119,
              photoHeight: templateEngine.getHeight(592.95),
              photoWidth: templateEngine.getWidth(557.56),
              angle: 0.2,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 6,
              top: 369,
              left: 3238,
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.ROTATE,
              photoNumber: 7,
              top: 854,
              left: 3434,
              photoHeight: templateEngine.getHeight(842),
              photoWidth: templateEngine.getWidth(786),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.SCALE,
              photoNumber: 7,
              top: 855,
              left: 4195,
              photoHeight: templateEngine.getHeight(842),
              photoWidth: templateEngine.getWidth(786),
            ),
            PhotoActionButton(
              buttonClass: ButtonClass.DELETE,
              photoNumber: 7,
              top: 49,
              left: 4195,
            ),
          ],
        ),
      ),
    );
  }
}
