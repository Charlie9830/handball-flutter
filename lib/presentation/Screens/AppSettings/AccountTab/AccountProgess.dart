import 'package:flutter/material.dart';

class AccountProgress extends StatelessWidget {
  final String activityName;

  AccountProgress({
    this.activityName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.only(bottom: 24),
            child: CircularProgressIndicator(),
          ),
          Text(activityName, style: Theme.of(context).textTheme.headline),  
        ],
      ),
    );
  }
}
