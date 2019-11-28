import 'package:flutter/material.dart';

class AppDrawerHeader extends StatelessWidget {
  final String email;
  final String displayName;
  final dynamic onSettingsButtonPressed;
  final dynamic onCreateProjectButtonPressed;
  final dynamic onActivityFeedButtonPressed;

  AppDrawerHeader({
    this.email,
    this.displayName,
    this.onCreateProjectButtonPressed,
    this.onSettingsButtonPressed,
    this.onActivityFeedButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(displayName ?? '',
                          style: Theme.of(context).textTheme.body2),
                      Text(email ?? '',
                          style: Theme.of(context).textTheme.body1),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: onSettingsButtonPressed,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    textColor:
                        Theme.of(context).buttonTheme.colorScheme.onPrimary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.add),
                        Text('Create Project')
                      ],
                    ),
                    onPressed: onCreateProjectButtonPressed,
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: onActivityFeedButtonPressed,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
