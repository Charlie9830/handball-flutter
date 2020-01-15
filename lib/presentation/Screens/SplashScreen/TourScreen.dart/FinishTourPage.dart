import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/styleMixins.dart';

class FinishTourPage extends StatelessWidget {
  const FinishTourPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headlineMixin = getHeadlineTextStyleMixin(Theme.of(context).brightness);

    return Container(
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text('Smash it Bro',
                  style: Theme.of(context).textTheme.headline.copyWith(
                        color: headlineMixin.color,
                        fontFamily: headlineMixin.fontFamily,
                        fontSize: headlineMixin.fontSize,
                        fontWeight: headlineMixin.fontWeight,
                      )),
            ),
            RaisedButton(
              child: Text('Finish'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ]),
    );
  }
}
