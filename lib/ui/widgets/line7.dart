import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instapanoflutter/util/util.dart';

class Line7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.width13Half,
      height: Constants.height2,
      margin: EdgeInsets.zero,
      decoration: new BoxDecoration(
        color: AppColors.pink,
        borderRadius: Constants.buttonBorderRadius,
      ),
    );
  }
}

class Plus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Line7(),
        Transform.rotate(
          angle: pi / 2,
          child: Line7(),
        )
      ],
    );
  }
}

class BottomLine7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.width18,
      height: Constants.height2Half,
      margin: EdgeInsets.zero,
      decoration: new BoxDecoration(
        color: AppColors.pink,
        borderRadius: Constants.buttonBorderRadius,
      ),
    );
  }
}

class BottomPlus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BottomLine7(),
        Transform.rotate(
          angle: pi / 2,
          child: BottomLine7(),
        )
      ],
    );
  }
}

