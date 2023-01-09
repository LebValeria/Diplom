import 'package:flutter/material.dart';
import 'package:instapanoflutter/util/util.dart';

import '../../ui.dart';

class DiscoverScreen extends StatefulWidget {
  static const routeName = "/dicover";

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  DiscoverScreenBloc bloc;

  @override
  void initState() {
    bloc = DiscoverScreenBloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Constants.height12),
      child: StreamBuilder<DiscoverScreenState>(
        stream: bloc.getTabState,
        initialData: DiscoverScreenState.firstTab(),
        builder: (context, snapshot) {
          final type = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: type.runtimeType == FirstTabDiscoverScreenState
                    ? buildFirstTab()
                    : buildSecondTab(),
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildFirstTab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildCollections(),
      ],
    );
  }

  Widget buildCollections() {
    return Flexible(
      child: ListView.separated(
        itemCount: 5,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 4)
            return SizedBox(
              height: 0,
            );
          return UnoCollection();
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: Constants.height24);
        },
      ),
    );
  }

  Widget buildSecondTab() {
    return Container(
        //child: Text('first'),
        );
  }
}
