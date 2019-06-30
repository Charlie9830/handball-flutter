import 'package:flutter/material.dart';

class AddListHintButton extends StatelessWidget {
  final onPressed;

  const AddListHintButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.playlist_add,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(width: 8.0),
            Text('Add list',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ))
          ],
        ),
        onPressed: onPressed);
  }
}
