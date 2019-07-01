import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ProjectModel.dart';

class MoveListBottomSheet extends StatelessWidget {
  final List<ProjectModel> projectOptions;
  const MoveListBottomSheet({Key key, this.projectOptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select a Project',
                  style: Theme.of(context).textTheme.subhead),
            ),
            Expanded(
              child: ListView(
                children: _getChildren(context),
                physics: AlwaysScrollableScrollPhysics(),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _getChildren(BuildContext context) {
    return projectOptions.map( (option) {
      return ListTile(
        title: Text(option.projectName),
        onTap: () => Navigator.of(context).pop(option.uid)
      );
    }).toList();
  }
}