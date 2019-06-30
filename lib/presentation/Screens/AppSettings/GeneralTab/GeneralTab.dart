import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/ThemeEditorContainer.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/ThemeEditor.dart';

class GeneralTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Theme', style: Theme.of(context).textTheme.subhead),
        ThemeEditorContainer(),
      ],
    );
  }
}
