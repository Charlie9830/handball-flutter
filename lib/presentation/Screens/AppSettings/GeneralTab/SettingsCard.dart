import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsCard({Key key, this.title, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(title ?? '', style: Theme.of(context).textTheme.subtitle),
            ),
            for (var child in children) 
            child,
          ]
        ),
      ),
    );
  }
}