import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instapanoflutter/ui/ui.dart';
import 'package:instapanoflutter/util/util.dart';

import 'util/dynamic.dart';

void main() => {
      WidgetsFlutterBinding.ensureInitialized(),
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]).then(
        (_) => runApp(
          InstaPano(),
        ),
      )
    };

class InstaPano extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            backgroundColor: Colors.transparent),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.white,
        //resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        body: InitScreen(),
      ),
    );
  }
}

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return CustomBottomNavigationBar();
  }
}
