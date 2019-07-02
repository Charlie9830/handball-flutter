import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReleaseNotesDialog extends StatelessWidget {
  const ReleaseNotesDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Release Notes'),
        ),
        body: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('assets/release_notes/test.md'),
          builder: (context, snapshot) {
          return Markdown(data: snapshot.data ?? 'Could not retreive Release Notes');
        }));
  }
}
