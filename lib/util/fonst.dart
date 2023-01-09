import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instapanoflutter/util/util.dart';

class AppTypography {
  static final headLine = TextStyle(
    color: AppColors.black,
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontSize: Constants.textSize32,
    letterSpacing: -0.24,
  );

  static final headLine2 = TextStyle(
    color: AppColors.black,
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontSize: Constants.textSize17,
    height: 1.47,
    letterSpacing: -0.24,
  );

  static final subhead = TextStyle(
    color: AppColors.black,
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: Constants.textSize17,
    letterSpacing: -0.24,
  );

  static final buttonText = TextStyle(
    color: AppColors.white,
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: Constants.textSize17,
    letterSpacing: -0.24,
  );

  static final timeText = TextStyle(
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static final price = TextStyle(
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    height: 1,
  );

  static final drawer = TextStyle(
    fontFamily: 'Roboto',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: Constants.textSize18,
    letterSpacing: -0.5,
    height: 3.11,
    color: Color(0xff141719),
  );

  static final appBar = TextStyle(
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontSize: Constants.textSize17,
    letterSpacing: -0.24,
    height: 1.18,
    color: AppColors.black,
  );

  static final listScroll = TextStyle(
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: Constants.textSize15,
    letterSpacing: -0.24,
    height: 1.33,
    color: AppColors.white,
  );

  static final photoNumber = TextStyle(
    fontFamily: 'SF Pro Rounded',
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontSize: 130,
    color: Color(0xff919191),
  );
}
