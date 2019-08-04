import 'package:flutter/material.dart';

class NoArchivedProjectsFallback extends StatelessWidget {
  const NoArchivedProjectsFallback({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Text("No archived projects"),
    );
  }
}