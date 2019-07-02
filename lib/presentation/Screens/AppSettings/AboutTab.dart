import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/ReleaseNotesDialog.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: Image.asset('assets/images/app_icon.png',
              height: 100, width: 100),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text('Handball', style: Theme.of(context).textTheme.headline),
        ),
        Text('Charlie Hall'),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Visit website'),
              ),
              FlatButton(
                child: Text('Licenses'),
                onPressed: () => showLicensePage(context: context),
              ),
              FlatButton(
                child: Text('Report a bug'),
              ),
              FlatButton(
                child: Text('Provide feedback')),
              FlatButton(
                child: Text('Release Notes'),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ReleaseNotesDialog(),
                )
              )
            ],
          ),
        )
      ],
    );
  }
}
