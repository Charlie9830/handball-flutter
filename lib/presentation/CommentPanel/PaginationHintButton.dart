import 'package:flutter/material.dart';

class PaginationHintButton extends StatelessWidget {
  final bool isPaginating;
  final bool isPaginationComplete;
  final dynamic onPressed;

  const PaginationHintButton(
      {Key key, this.isPaginationComplete, this.isPaginating, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getChild(context);
  }

  Widget _getChild(BuildContext context) {
    if (isPaginating) {
      return CircularProgressIndicator();
    }

    if (isPaginationComplete) {
      return Text('No more comments',
          style: Theme.of(context).textTheme.caption);
    } else {
      return FlatButton(
        child: Text('Show more'),
        onPressed: onPressed,
      );
    }
  }
}
