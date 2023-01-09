import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/ui/ui.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class BlackFamousPreFields extends PreFields {
  final DynamicTemplateEngine templateEngine;

  BlackFamousPreFields({@required this.templateEngine})
      : super(fieldItems: getItems(templateEngine));

  static List<FieldItem> getItems(DynamicTemplateEngine templateEngine) {
    List<FieldItem> fieldItems = [];
    TextEditingController textEditingController1 = TextEditingController();
    textEditingController1.text = 'STAY SALTY';
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
            textObjectWidth: 500,
            textObjectHeight: 300,
            fontSize: Constants.textSize12,
            color: Color(0xffE34A6F),
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(55),
              templateEngine.getHeight(326),
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
        dragTextBloc: DragTextBloc(),
        scaleAndRotate: ScaleAndRotate(
          rotate: -90 * pi / 180,
        ),
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
    textEditingController2.text = 'FAMOUS';
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
            controller: textEditingController2,
            textObjectWidth: 450,
            textObjectHeight: 250,
            fontSize: Constants.textSize14,
            color: Color(0xffE34A6F),
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(1210),
              templateEngine.getHeight(600),
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
    textEditingController3.text = 'PRETTY';
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
            controller: textEditingController3,
            textObjectWidth: 430,
            textObjectHeight: 250,
            fontSize: Constants.textSize14,
            color: Color(0xffE34A6F),
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(1605),
              templateEngine.getHeight(200),
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
    textEditingController4.text = 'BEAUTY';
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
            textObjectWidth: 450,
            textObjectHeight: 250,
            fontSize: Constants.textSize14,
            color: Color(0xffE34A6F),
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(1980 ),
              templateEngine.getHeight(600),
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
    textEditingController5.text = 'She Is\nBuilding\nHer Empire';
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
            controller: textEditingController5,
            textObjectWidth: 400,
            textObjectHeight: 400,
            textAlign: TextAlign.center,
            fontSize: Constants.textSize12,
            color: Color(0xffE34A6F),
            focusNode: FocusNode(),
            visible: true,
            offset: Offset(
              templateEngine.getHeight(4220),
              templateEngine.getHeight(330),
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

    return fieldItems;
  }
}
