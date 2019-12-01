import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskMetadata.dart';
import 'package:handball_flutter/presentation/TaskMetadataListItem/TaskMetadataValueGroup.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskMetadataExpansionTile extends StatefulWidget {
  final TaskMetadata metadata;
  TaskMetadataExpansionTile({Key key, this.metadata}) : super(key: key);

  _TaskMetadataExpansionTileState createState() => _TaskMetadataExpansionTileState();
}

class _TaskMetadataExpansionTileState extends State<TaskMetadataExpansionTile> {
  bool isExpanded;
  
  @override
  void initState() {
    super.initState();

    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
          onExpansionChanged: (value) => setState( () => isExpanded = value),
          
          title: Text( isExpanded ? '' : _getShortMetadataText()),
          children: <Widget>[
            TaskMetadataValueGroup(
              title: 'Created',
              by: widget.metadata.createdBy,
              when: widget.metadata.createdOn,
            ),
            TaskMetadataValueGroup(
              title: 'Updated',
              by: widget.metadata.updatedBy,
              when: widget.metadata.updatedOn,
            ),
            TaskMetadataValueGroup(
              title: 'Completed',
              by: widget.metadata.completedBy,
              when: widget.metadata.completedOn,
            )
          ],
        );
  }

  String _getShortMetadataText() {
    if (widget.metadata == null || widget.metadata.isAvailable == false || widget.metadata?.createdOn == null) {
      return 'Metadata unavailable';
    }

    return 'Created ${timeago.format(widget.metadata.createdOn)} by ${widget.metadata.createdBy}';

    // return 'Created by ${widget.metadata.createdBy} on $formattedDate at $formattedTime ';
  }
}