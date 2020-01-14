import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      color: Color.fromARGB(255, 0, 11, 19),
      child: Image(
          image: AssetImage('assets/images/app_icon.png'),
          width: MediaQuery.of(context).size.width / 3),
    );
  }
}
