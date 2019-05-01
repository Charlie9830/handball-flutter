import 'package:handball_flutter/enums.dart';

class TextInputDialogModel {
  final bool isOpen;
  final String text;
  final onOkay;
  final onCancel;

  TextInputDialogModel({this.isOpen, this.text, this.onOkay, this.onCancel});
}

class TextInputDialogResult {
  final DialogResult result;
  final String value;

  TextInputDialogResult({this.result, this.value});
}