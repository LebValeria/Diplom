import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/ui/bloc/blocs.dart';
import 'package:instapanoflutter/util/text_style_checker.dart';
import 'package:rxdart/rxdart.dart';

enum language { ALL, CYRILLIC, ARABIC }

class TextData {
  Offset offset;
  TextEditingController controller;
  TextStyle textStyle;
  Color color;
  double fontSize;
  TextDirection textDirection;
  FocusNode focusNode;
  bool visible;
  bool requestFocusAfterAdd;
  final double textObjectHeight;
  final double textObjectWidth;
  final TextAlign textAlign;

  TextData({
    this.offset = Offset.zero,
    @required this.color,
    @required this.controller,
    @required this.textStyle,
    @required this.fontSize,
    this.focusNode,
    @required this.visible,
    @required this.textDirection,
    this.requestFocusAfterAdd = true,
    this.textObjectHeight = 300,
    this.textObjectWidth = 550,
    this.textAlign = TextAlign.left,
  })  : assert(color != null),
        assert(textStyle != null),
        assert(controller != null),
        assert(textStyle != null),
        assert(fontSize != null),
        assert(focusNode != null),
        assert(visible != null),
        assert(textDirection != null);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = {
      'dx': this.offset.dx,
      'dy': this.offset.dy,
    };
    data['controller'] = this.controller.text;
    data['textStyle'] = {
      'fontFamily': TextStyleChecker.fontFamilyConverter(
          this.textStyle.fontFamilyFallback[0]),
      'letterSpacing': this.textStyle.letterSpacing,
      'height': this.textStyle.height,
      'fontStyle': this.textStyle.fontStyle.toString(),
      'fontWeight': this.textStyle.fontWeight.toString(),
    };
    data['color'] = this.color.value;
    data['fontSize'] = this.fontSize;
    data['textDirection'] = this.textDirection.toString();
    data['visible'] = this.visible;
    data['requestFocusAfterAdd'] = this.requestFocusAfterAdd;
    data['textObjectHeight'] = this.textObjectHeight;
    data['textObjectWidth'] = this.textObjectWidth;
    data['textAlign'] = this.textAlign.toString();
    return data;
  }

  factory TextData.fromJson(Map<String, dynamic> json) {
    TextEditingController _controller = TextEditingController();
    _controller.text = json['controller'];
    return TextData(
      offset: Offset(json['offset']['dx'], json['offset']['dy']),
      controller: _controller,
      textStyle: GoogleFonts.getFont(
        json['textStyle']['fontFamily'],
        fontStyle: TextStyleChecker.toFontStyle(json['textStyle']['fontStyle']),
        fontWeight:
            TextStyleChecker.toFontWeight(json['textStyle']['fontWeight']),
        letterSpacing: json['textStyle']['letterSpacing'],
        height: json['textStyle']['height'],
      ),
      color: Color(json['color']),
      fontSize: json['fontSize'],
      textDirection: TextStyleChecker.toTextDirection(json['textDirection']),
      visible: json['visible'],
      focusNode: FocusNode(),
      requestFocusAfterAdd: json['requestFocusAfterAdd'],
      textObjectHeight: json['textObjectHeight'],
      textObjectWidth: json['textObjectWidth'],
      textAlign: TextStyleChecker.toTextAlign(json['textAlign']),
    );
  }
}

class FieldItem {
  ///Данные поля, которые уходят в [Stream]
  final BehaviorSubject<TextData> textData;

  /// != null при копировании текстового поля, в остальных случаях null
  ScaleAndRotate scaleAndRotate;

  ///
  final BehaviorSubject<StyleData> styleData;

  ///Инициализируем при создании текстового поля для того,
  ///чтобы не сбрасывались значения в превью
  final DragTextBloc dragTextBloc;

  ///По дефолту [False], [True] ставится во время сохранения параметров.
  ///Нужно для инициализации [DragTextBloc] после сохранения
  final bool fromSave;

  FieldItem({
    @required this.textData,
    @required this.styleData,
    this.scaleAndRotate,
    @required this.dragTextBloc,
    this.fromSave = false,
  })  : assert(textData != null),
        assert(styleData != null),
        assert(dragTextBloc != null);

  factory FieldItem.fromJson(Map<String, dynamic> json) {
    TextData textData = TextData.fromJson(json['textData']);
    StyleData styleData = StyleData.fromJson(json['styleData']);
    DragTextBloc dragTextBloc = DragTextBloc();
    dragTextBloc.fromJson(
        ScaleAndRotate.fromJson(json['dragTextBloc']['scaleAndRotate']),
        json['dragTextBloc']['maxScroll']);
    return FieldItem(
      textData: BehaviorSubject<TextData>.seeded(textData),
      styleData: BehaviorSubject<StyleData>.seeded(styleData),
      dragTextBloc: dragTextBloc,
      fromSave: true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textData'] = this.textData.value.toJson();
    data['styleData'] = this.styleData.value.toJson();
    data['dragTextBloc'] = this.dragTextBloc.toJson();
    data['fromSave'] = true;
    return data;
  }
}

class StyleData {
  TextDirection textDirection;
  FontWeight fontWeight;
  FontStyle fontStyle;
  List<ConverterName> converterList;

  StyleData({
    this.textDirection,
    this.fontStyle,
    this.fontWeight,
    this.converterList = const [
      ConverterName(fontWeight: FontWeight.w100, displayName: 'Thin'),
      ConverterName(fontWeight: FontWeight.w200, displayName: 'Ultralight'),
      ConverterName(fontWeight: FontWeight.w300, displayName: 'Light'),
      ConverterName(fontWeight: FontWeight.w400, displayName: 'Regular'),
      ConverterName(fontWeight: FontWeight.w500, displayName: 'Medium'),
      ConverterName(fontWeight: FontWeight.w600, displayName: 'Semibold'),
      ConverterName(fontWeight: FontWeight.w700, displayName: 'Bold'),
      ConverterName(fontWeight: FontWeight.w800, displayName: 'Heavy'),
      ConverterName(fontWeight: FontWeight.w900, displayName: 'Black'),
    ],
  });

  factory StyleData.fromJson(Map<String, dynamic> json) {
    return StyleData(
      textDirection: TextStyleChecker.toTextDirection(json['textDirection']),
      fontStyle: TextStyleChecker.toFontStyle(json['fontStyle']),
      fontWeight: TextStyleChecker.toFontWeight(json['fontWeight']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textDirection'] = this.textDirection.toString();
    data['fontStyle'] = this.fontStyle.toString();
    data['fontWeight'] = this.fontWeight.toString();
    return data;
  }
}

class ConverterName {
  final FontWeight fontWeight;
  final String displayName;

  const ConverterName({
    @required this.fontWeight,
    this.displayName = '',
  });
}
