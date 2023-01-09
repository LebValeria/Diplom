import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:instapanoflutter/ui/ui.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

class UnoCollection extends StatefulWidget {
  UnoCollection();

  @override
  _UnoCollectionState createState() => _UnoCollectionState();
}

class _UnoCollectionState extends State<UnoCollection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Constants.width24),
      height: Constants.height285,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Uno Post Collection',
            style: AppTypography.appBar.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Constants.height12),
          buildList(),
          Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget buildList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Constants.height238,
      child: ListView.separated(
        itemCount: templateName.values.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          templateName template = templateName.values[index];
          return PreviewContainer(
            template: Provider.of<Templates>(context).templates[template],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: Constants.width16);
        },
      ),
    );
  }
}
