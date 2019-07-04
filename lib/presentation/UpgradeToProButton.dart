import 'package:flutter/material.dart';

class UpgradeToProButton extends StatelessWidget {
  const UpgradeToProButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
      Icon(
          Icons.new_releases,
          color: Theme.of(context).accentColor,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Text("Upgrade to Pro", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w700)),
      ),
    ]),
        ));
  }

  void _handleTap() async {

  }
}
