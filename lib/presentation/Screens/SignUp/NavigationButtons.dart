import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final String rightButtonText;
  final String leftButtonText;
  final dynamic onRightButtonPressed;
  final dynamic onLeftButtonPressed;

  NavigationButtons({
    this.rightButtonText = 'Next',
    this.leftButtonText = 'Back',
    this.onRightButtonPressed,
    this.onLeftButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(leftButtonText),
                onPressed: onLeftButtonPressed,
              ),
              RaisedButton(
                child: Text(rightButtonText),
                onPressed: onRightButtonPressed,
              )
            ],
          )
        ],
    );
  }
}
