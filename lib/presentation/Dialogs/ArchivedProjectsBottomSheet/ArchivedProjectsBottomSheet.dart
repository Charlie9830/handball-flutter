import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ArchivedProject.dart';
import 'package:handball_flutter/presentation/Dialogs/ArchivedProjectsBottomSheet/NoArchivedProjectsFallback.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArchivedProjectsBottomSheet extends StatelessWidget {
  final List<ArchivedProjectModel> projectOptions;
  const ArchivedProjectsBottomSheet({Key key, this.projectOptions})
      : super(key: key);

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
              child: Text('Choose project to restore',
                  style: Theme.of(context).textTheme.subhead),
            ),
            Expanded(
                child: PredicateBuilder(
              predicate: () => projectOptions.isNotEmpty,
              childIfTrue: ListView(
                children: _getChildren(context),
                physics: AlwaysScrollableScrollPhysics(),
              ),
              childIfFalse: NoArchivedProjectsFallback(),
            )),
          ],
        );
      },
    );
  }

  List<Widget> _getChildren(BuildContext context) {
    return projectOptions.map((option) {
      var subtitleText =
          option.archivedOn == null ? '' : timeago.format(option.archivedOn);

      return ListTile(
          title: Text(option.archivedProjectName ?? ''),
          subtitle: Text(subtitleText),
          onTap: () => Navigator.of(context).pop(option.uid));
    }).toList();
  }
}
