import 'package:flutter/material.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';

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
                  RaisedButton(
                    textColor:
                        Theme.of(context).buttonTheme.colorScheme.onPrimary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.add),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text('Create Project'),
                        )
                      ],
                    ),
                    onPressed: onCreateProjectButtonPressed,
                  ),
                  if (EnableStates.of(context).state.isLoggedIn == true)
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
