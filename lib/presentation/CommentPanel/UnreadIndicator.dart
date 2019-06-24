import 'package:flutter/material.dart';

class UnreadIndicator extends StatelessWidget {
  final bool isUnread;

  const UnreadIndicator({
    Key key,
    this.isUnread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: SizedBox(width: isUnread == true ? 16 : 0, child: Container(color: Colors.blue)),
    );
  }
}