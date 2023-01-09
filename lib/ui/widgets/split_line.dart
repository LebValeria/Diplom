import 'package:flutter/material.dart';
import 'package:instapanoflutter/util/util.dart';

class SplitLine extends StatelessWidget {
  final double height;

  SplitLine({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? Constants.height241,
      width: Constants.width1,
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
    );
  }
}
