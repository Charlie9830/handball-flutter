import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/HintButtons/HintButtonBase.dart';

class NoTaskListsHintButton extends StatelessWidget {
  final dynamic onPressed;

  const NoTaskListsHintButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HintButtonBase(
      text: 'No lists',
      buttonText: 'Create a list',
      onPressed: onPressed,
    );
  }
}