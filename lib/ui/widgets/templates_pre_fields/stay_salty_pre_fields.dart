import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/ui/ui.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class StaySaltyPreFields extends PreFields {
  final DynamicTemplateEngine templateEngine;

  StaySaltyPreFields({@required this.templateEngine})
      : super(fieldItems: getItems(templateEngine));

  static List<FieldItem> getItems(DynamicTemplateEngine templateEngine) {
    List<FieldItem> fieldItems = [];
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = 'STAY SALTY';
    fieldItems.add(
      FieldItem(
        textData: BehaviorSubject<TextData>.seeded(
          TextData(
            textStyle: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.1,
              height: 1.18,
              color: Color(0xffF5F3F5),
            ),
            controller: textEditingController,
            textObjectWidth: 650,
            textObjectHeight: 500,
            fontSize: Constants.textSize32,
            color: Color(0xffF5F3F5),
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(16),
              templateEngine.getHeight(55),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        dragTextBloc: DragTextBloc(),
        styleData: BehaviorSubject<StyleData>.seeded(
          StyleData(
            fontWeight: FontWeight.w900,
            textDirection: TextDirection.ltr,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );

    TextEditingController textEditingController1 = TextEditingController();
    textEditingController1.text = 'Just A Girl\n Boos\n Building\n Her Empire';
    fieldItems.add(
      FieldItem(
        textData: BehaviorSubject<TextData>.seeded(
          TextData(
            textStyle: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.1,
              height: 1.4,
            ),
            controller: textEditingController1,
            textObjectWidth: 460,
            textObjectHeight: 550,
            fontSize: Constants.textSize14,
            color: Color(0xffF5F3F5),
            textAlign: TextAlign.center,
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(1390),
              templateEngine.getWidth(254),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        dragTextBloc: DragTextBloc(),
        styleData: BehaviorSubject<StyleData>.seeded(
          StyleData(
            fontWeight: FontWeight.w900,
            textDirection: TextDirection.ltr,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );

    TextEditingController textEditingController2 = TextEditingController();
    textEditingController2.text = 'SWIP TO SEE MORE';
    fieldItems.add(
      FieldItem(
        textData: BehaviorSubject<TextData>.seeded(
          TextData(
            textStyle: GoogleFonts.neucha(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.1,
              height: 1.18,
            ),
            controller: textEditingController2,
            textObjectWidth: 500,
            textObjectHeight: 150,
            fontSize: Constants.textSize8,
            color: Colors.black,
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(1662),
              -templateEngine.getHeight(12),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        dragTextBloc: DragTextBloc(),
        styleData: BehaviorSubject<StyleData>.seeded(
          StyleData(
            fontWeight: FontWeight.w900,
            textDirection: TextDirection.ltr,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );

    TextEditingController textEditingController3 = TextEditingController();
    textEditingController3.text = 'STAY SALTY';
    fieldItems.add(
      FieldItem(
        textData: BehaviorSubject<TextData>.seeded(
          TextData(
            textStyle: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.1,
              height: 1.18,
            ),
            controller: textEditingController3,
            textObjectWidth: 1100,
            textObjectHeight: 300,
            fontSize: Constants.textSize32,
            color: Color(0xffF5F3F5),
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(2862),
              templateEngine.getHeight(99),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        dragTextBloc: DragTextBloc(),
        styleData: BehaviorSubject<StyleData>.seeded(
          StyleData(
            fontWeight: FontWeight.w900,
            textDirection: TextDirection.ltr,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );

    TextEditingController textEditingController4 = TextEditingController();
    textEditingController4.text = 'Keep Going';
    fieldItems.add(
      FieldItem(
        textData: BehaviorSubject<TextData>.seeded(
          TextData(
            textStyle: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.1,
              height: 1.4,
            ),
            controller: textEditingController4,
            textObjectWidth: 400,
            textObjectHeight: 300,
            fontSize: Constants.textSize14,
            color: Color(0xffF5F3F5),
            textAlign: TextAlign.center,
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(3574),
              templateEngine.getHeight(716),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        dragTextBloc: DragTextBloc(),
        styleData: BehaviorSubject<StyleData>.seeded(
          StyleData(
            fontWeight: FontWeight.w900,
            textDirection: TextDirection.ltr,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );

    TextEditingController textEditingController5 = TextEditingController();
    textEditingController5.text = 'Rise Good Things';
    fieldItems.add(
      FieldItem(
        textData: BehaviorSubject<TextData>.seeded(
          TextData(
            textStyle: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.normal,
              letterSpacing: 0.1,
              height: 1.18,
            ),
            controller: textEditingController5,
            textObjectWidth: 750,
            textObjectHeight: 250,
            fontSize: Constants.textSize14,
            color: Colors.black,
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(5004),
              templateEngine.getHeight(579),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        scaleAndRotate: ScaleAndRotate(
          previousScaleY: 1,
          previousScaleX: 1,
          previousScale: 1,
          scaleY: 1,
          scaleX: 1,
          scale: 1,
          rotate: -90 * pi / 180,
        ),
        dragTextBloc: DragTextBloc(),
        styleData: BehaviorSubject<StyleData>.seeded(
          StyleData(
            fontWeight: FontWeight.w900,
            textDirection: TextDirection.ltr,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );

    return fieldItems;
  }
}
