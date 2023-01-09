import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleChecker {
  static bool contain(List fontWeights, FontWeight fontWeight) {
    return fontWeights.contains(fontWeight);
  }

  static String fontFamilyConverter(String fontFamily) {
    if (fontFamily == 'Exo2')
      fontFamily = 'Exo 2';
    else if (fontFamily == 'IBMPlexSerif')
      fontFamily = 'IBM Plex Serif';
    else if (fontFamily == 'MPLUS1p')
      fontFamily = 'M PLUS 1p';
    else if (fontFamily == 'PTMono')
      fontFamily = 'PT Mono';
    else if (fontFamily == 'PressStart2P')
      fontFamily = 'Press Start 2P';
    else {
      final pascalWords  = RegExp(r"(?:[A-Z]+|^)[a-z]*");
      List<String> getPascalWords(String input) =>
          pascalWords.allMatches(input).map((m) => m[0]).toList();
      fontFamily = getPascalWords(fontFamily).join(' ');
    }
    return fontFamily;
  }

  static TextDirection toTextDirection(String textDirection) {
    switch(textDirection) {
      case('TextDirection.ltr'):
        return TextDirection.ltr;
      case('TextDirection.rtl'):
        return TextDirection.rtl;
    }
    return null;
  }

  static FontStyle toFontStyle(String fontStyle) {
    switch(fontStyle) {
      case('FontStyle.normal'):
        return FontStyle.normal;
      case('FontStyle.italic'):
        return FontStyle.italic;
    }
    return null;
  }

  static FontWeight toFontWeight(String fontWeight) {
    switch(fontWeight) {
      case('FontWeight.w100'):
        return FontWeight.w100;
      case('FontWeight.w200'):
        return FontWeight.w200;
      case('FontWeight.w300'):
        return FontWeight.w300;
      case('FontWeight.w400'):
        return FontWeight.w400;
      case('FontWeight.w500'):
        return FontWeight.w500;
      case('FontWeight.w600'):
        return FontWeight.w600;
      case('FontWeight.w700'):
        return FontWeight.w700;
      case('FontWeight.w800'):
        return FontWeight.w800;
      case('FontWeight.w900'):
        return FontWeight.w900;
    }
    return null;
  }

  static TextAlign toTextAlign(String textAlign) {
    switch(textAlign) {
      case('TextAlign.left'):
        return TextAlign.left;
      case('TextAlign.right'):
        return TextAlign.right;
      case('TextAlign.center'):
        return TextAlign.center;
      case('TextAlign.justify'):
        return TextAlign.justify;
      case('TextAlign.start'):
        return TextAlign.start;
      case('TextAlign.end'):
        return TextAlign.end;
    }
    return null;
  }
}
