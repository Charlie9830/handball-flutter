import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/presentation/CommentPanel/UnreadIndicator.dart';

class Comment extends StatelessWidget {
  final String displayName;
  final String timeAgoText;
  final String text;
  final bool isUnread;
  final dynamic onDelete;
  const Comment(
      {Key key,
      this.displayName = '',
      this.text = '',
      this.timeAgoText = '',
      this.isUnread = true,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        enabled: onDelete != null,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.redAccent,
            icon: Icons.delete,
            onTap: onDelete,
          )
        ],
        child: Padding(
          padding: EdgeInsets.only(
              left: isUnread == true ? 0 : 4, right: 8),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                UnreadIndicator(isUnread: isUnread),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(displayName ?? '',
                                style: Theme.of(context).textTheme.caption),
                            Text(timeAgoText ?? '',
                                style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(text),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
