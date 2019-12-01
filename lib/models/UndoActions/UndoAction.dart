import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:meta/meta.dart';

abstract class UndoActionModel {
  UndoActionType type;

  UndoActionModel({
    @required this.type,
  });

  String toJSON();
}
