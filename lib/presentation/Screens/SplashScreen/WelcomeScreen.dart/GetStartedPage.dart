import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/styleMixins.dart';

class GetStartedPage extends StatelessWidget {
  final dynamic onCreateAccountButtonPressed;
  final dynamic onSignInButtonPressed;

  const GetStartedPage({
    Key key,
    this.onCreateAccountButtonPressed,
    this.onSignInButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headlineMixin = getHeadlineTextStyleMixin(Theme.of(context).brightness);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text('Lets get Started',
                  style: Theme.of(context).textTheme.headline.copyWith(
                        color: headlineMixin.color,
                        fontFamily: headlineMixin.fontFamily,
                        fontSize: headlineMixin.fontSize,
                        fontWeight: headlineMixin.fontWeight,
                      )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
              child: RaisedButton(
                child: Text('Create account'),
                color: Theme.of(context).primaryColor,
                onPressed: onCreateAccountButtonPressed,
              ),
            ),
            FlatButton(
              child: Text('Sign in to an existing account'),
              onPressed: onSignInButtonPressed,
            )
          ]),
    );
  }
}
