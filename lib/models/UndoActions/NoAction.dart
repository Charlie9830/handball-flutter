import 'package:handball_flutter/models/UndoActions/UndoAction.dart';

class NoAction extends UndoActionModel {
  NoAction() : super(type: null,);

  @override
  String toJSON(){}
}