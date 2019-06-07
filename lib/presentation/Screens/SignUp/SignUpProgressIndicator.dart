import 'package:flutter/material.dart';

class SignUpProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:
          SizedBox(height: 48, width: 48, child: CircularProgressIndicator()),
    );
  }
}
