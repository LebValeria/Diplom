import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class CustomBottomNavigationBar extends StatefulWidget {
  static const routeName = "/navigator";

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  NavigatorScreenBloc _bloc;
  StreamSubscription _subscription;
  int index = 0;

  @override
  void initState() {
    _bloc = NavigatorScreenBloc();

    _bloc.getSaveTemplatesFromMemory();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: Templates(),
        ),
        Provider.value(
          value: _bloc,
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: AppColors.white,
        // body: Provider.value(
        //   value: _scaffoldKey,
        //   child: NavigatorBody(
        //     navigatorScreenBloc: _bloc,
        //   ),
        // ),
        body: IndexedStack(
          index: index,
          children: <Widget>[
            DiscoverScreen(),
            MyProjectsScreen(),
          ],
        ),
        // extendBody: true,
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: Constants.height83,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            color: AppColors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(0, -10),
                blurRadius: 30,
                color: Color(0xffe6e6e6),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildFirstItem(index == 0),
              buildSecondItem(index == 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstItem(bool type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = 0;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Constants.height48,
        width: Constants.width48,
        decoration: type
            ? BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.pink,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xfffdc4de),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 10),
            ),
          ],
        )
            : null,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/union.svg',
            height: Constants.height20,
            width: Constants.width20,
            color: type ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget buildSecondItem(bool type) {
    return GestureDetector(
      onTap: () {
        print('dsfsdfs');
        setState(() {
          index = 1;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Constants.height48,
        width: Constants.width48,
        decoration: type
            ? BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.pink,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xfffdc4de),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 10),
            ),
          ],
        )
            : null,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/camera.svg',
            height: Constants.height20,
            width: Constants.width20,
            color: type ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
