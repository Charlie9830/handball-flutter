import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/ThemeEditorContainer.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/SettingsCard.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/ThemeEditor.dart';

class GeneralTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SettingsCard(
            title: 'Theme',
            children: <Widget>[
              ThemeEditorContainer(),
            ],
          ),
          SettingsCard(title: 'Feedback', children: <Widget>[
            ListTile(
              leading: Icon(Icons.stars),
              title: Text('Rate the app'),
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Provide feedback'),
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Submit bug report'),
            )
          ]),
          SettingsCard(
            title: 'Help and Support',
            children: <Widget>[
              ListTile(
                title: Text('Help Center'),
              ),
              ListTile(
                title: Text('Email support'),
              ),
            ],
          ),
          SettingsCard(
            title: 'About',
            children: <Widget>[
              ListTile(
                title: Text('Visit website'),
              ),
              ListTile(
                title: Text('Privacy policy'),
              ),
              ListTile(
                title: Text('End User License Agreement'),
              ),
              ListTile(
                  title: Text('Third party licenes'),
                  onTap: () => showLicensePage(
                      context: context, applicationName: 'Handball')),
              ListTile(
                title: Text('Version'),
                subtitle: Text('0.0.16 build 47'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
