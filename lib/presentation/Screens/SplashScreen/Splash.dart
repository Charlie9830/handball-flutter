import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Material(
        elevation: 15,
        borderRadius: BorderRadius.circular(8),
        child: Image(
          image: AssetImage('assets/images/app_icon.png'),
          width: MediaQuery.of(context).size.width / 3),
    ));
  }
}
