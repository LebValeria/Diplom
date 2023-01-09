import 'dart:async';
import 'dart:convert';

import 'package:instapanoflutter/util/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs.dart';

class NavigatorScreenBloc extends Bloc {
  final _saveTemplates = BehaviorSubject<List>();

  Stream<List> get getSaveTemplates => _saveTemplates.stream;

  NavigatorScreenBloc() {
    subjects = [
      _saveTemplates,
    ];
    subscriptions = [];
  }

  Future<void> getSaveTemplatesFromMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localData = prefs.getString(Constants.saveTemplateString);
    if (localData != null) _saveTemplates.add(jsonDecode(localData));
  }

  Future<void> updateSaveTemplates(List templates) async {
    _saveTemplates.add(templates);
  }
}
