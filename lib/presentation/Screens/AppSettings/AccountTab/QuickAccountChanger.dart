import 'package:flutter/material.dart';

class QuickAccountChanger extends StatelessWidget {
  final dynamic onAccountChange;

  const QuickAccountChanger({Key key, this.onAccountChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 0.0,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: ListTile(
            title: Text('User A'),
            onTap: () => onAccountChange('a@test.com', 'adingusshrew'),
          ),
        ),
        SizedBox(
          width: 100,
          child: ListTile(
            title: Text('User B'),
            onTap: () => onAccountChange('b@test.com', 'adingusshrew'),
          ),
        ),
        SizedBox(
          width: 100,
          child: ListTile(
            title: Text('User C'),
            onTap: () => onAccountChange('c@test.com', 'adingusshrew'),
          ),
        ),
        // SizedBox(
        //   width: 100,
        //   child: ListTile(
        //     title: Text('User D'),
        //     onTap: () => onAccountChange('d@test.com', 'adingusshrew'),
        //   ),
        // ),
        // SizedBox(
        //   width: 100,
        //   child: ListTile(
        //     title: Text('User E'),
        //     onTap: () => onAccountChange('E@test.com', 'adingusshrew'),
        //   ),
        // ),
        // SizedBox(
        //   width: 100,
        //   child: ListTile(
        //     title: Text('Agent Z'),
        //     onTap: () => onAccountChange('z@test.com', 'adingusshrew'),
        //   ),
        // ),
      ],
    );
    // return ListView(
    //     shrinkWrap: true,
    //     physics: AlwaysScrollableScrollPhysics(),
    //     children: <Widget>[]);
  }
}
