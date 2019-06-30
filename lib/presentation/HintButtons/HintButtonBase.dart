import 'package:flutter/material.dart';

class HintButtonBase extends StatelessWidget {
  final String text;
  final String buttonText;
  final dynamic onPressed;

  const HintButtonBase({Key key, this.onPressed, this.text, this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(text ?? ''),
          SizedBox(
            height: 16.0,
          ),
          OutlineButton(
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).accentColor,
            child: Text(buttonText ?? ''),
            onPressed: onPressed,
          )
        ],
      )
    );
  }
}