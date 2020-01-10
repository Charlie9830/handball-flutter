import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/presentation/CommentPanel/Comment.dart';
import 'package:handball_flutter/presentation/CommentPanel/PaginationHintButton.dart';
import 'package:handball_flutter/presentation/ReactiveAnimatedList.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentPanel extends StatefulWidget {
  final bool isGettingComments;
  final bool isPaginatingComments;
  final bool isInteractive;
  final bool isPaginationComplete;
  final List<CommentViewModel> viewModels;
  final ScrollController scrollController;
  final dynamic onPaginate;
  final dynamic onPressed;

  CommentPanel({
    Key key,
    this.isInteractive = true,
    this.isGettingComments = false,
    this.isPaginatingComments = false,
    this.scrollController,
    this.viewModels,
    this.isPaginationComplete = false,
    this.onPaginate,
    this.onPressed,
  }) : super(key: key);

  @override
  _CommentPanelState createState() => _CommentPanelState();
}

class _CommentPanelState extends State<CommentPanel> {
  SlidableController _slidableController;

  @override
  void initState() { 
    super.initState();
    _slidableController = SlidableController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          //color: Theme.of(context).colorScheme.background,
          alignment: Alignment.center,
          child: _getChild(),
        ));
  }

  Widget _getChild() {
    if (widget.isGettingComments) {
      return CircularProgressIndicator();
    }

    if (widget.viewModels.length == 0) {
      return Text('No comments.');
    }

    return ReactiveAnimatedList(
      controller: widget.scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      children: _getChildren(),
    );
  }

  List<Widget> _getChildren() {
    if (widget.viewModels.length == 0) {
      return <Widget>[
        Container(
          key: Key('no-comments-key'),
          child: Text('No comments yet. Post some below!'),
        )
      ];
    }

    List<Widget> widgets = widget.viewModels.reversed.map((vm) {
      return Container(
        key: Key(vm.data.uid),
        child: Comment(
          key: Key(vm.data.uid),
          slidableController: _slidableController,
          displayName: vm.data.displayName,
          text: vm.data.text,
          timeAgoText: _getTimeAgoText(vm),
          isUnread: vm.isUnread,
          onDelete: vm.onDelete,
        ),
      );
    }).toList();

    // Include the show more pagination hint.
    if (widget.isInteractive) {
      widgets.insert(
          0,
          Container(
            key: Key('Pagination Hint'),
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: PaginationHintButton(
              isPaginating: widget.isPaginatingComments,
              isPaginationComplete: widget.isPaginationComplete,
              onPressed: widget.onPaginate,
            ),
          ));
    }

    return widgets;
  }

  String _getTimeAgoText(CommentViewModel vm) {
    if (vm.data.isSynced) {
      if (vm.data.created == null) {
        return '';
      }

      return timeago.format(vm.data.created);
    } else {
      return 'Not synced';
    }
  }
}
