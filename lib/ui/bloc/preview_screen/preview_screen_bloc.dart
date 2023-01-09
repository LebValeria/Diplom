import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:instapanoflutter/ui/bloc/blocs.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class PreviewScreenBloc extends Bloc {
  ConstructorBloc _bloc;
  Template _template;

  final _showProgressIndicator = BehaviorSubject<bool>();

  final _saveVisible = BehaviorSubject<bool>();

  final List<BehaviorSubject<Uint8List>> _listPreview = [];

  PreviewScreenBloc({
    @required ConstructorBloc bloc,
    @required Template template,
  }) {
    this._bloc = bloc;
    this._template = template;

    this.addPreviewImage();
    subjects = [_showProgressIndicator, _saveVisible];
  }

  List get getListPreview => _listPreview;

  Stream get getShowProgressIndicator => _showProgressIndicator.stream;

  Stream get getShowSaveButton => _saveVisible.stream;

  void addTrueProgressIndicator() {
    _showProgressIndicator.add(true);
  }

  void addFalseProgressIndicator() {
    _showProgressIndicator.add(false);
  }

  void addPreviewImage() {
    for (int i = 0; i < _template.scrollCountInPreview + 1; i++) {
      _listPreview.add(BehaviorSubject<Uint8List>());
    }
  }

  Future<void> createPreviewImage() async {
    for (int i = 0; i < _template.scrollCountInPreview + 1; i++) {
      var bytes = await _bloc.createPreviewImage(index: i, bloc: _bloc);
      _listPreview[i].add(bytes);
      await Future.delayed(Duration(milliseconds: 100));
    }
    _saveVisible.add(true);
  }
}
