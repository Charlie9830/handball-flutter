import 'package:flutter/material.dart';

class NoTaskEntityFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("No Task selected"),
            Text("Task may have been deleted by another user or device")
          ],
        )
      )
    );
  }
}