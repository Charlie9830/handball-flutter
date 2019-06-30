import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/presentation/HintButtons/HintButtonBase.dart';
import 'package:handball_flutter/presentation/HintButtons/NoTaskListsHintButton.dart';
import 'package:handball_flutter/presentation/HintButtons/SingleListNoTasksHint.dart';

class HomeScreenHintsMask extends StatelessWidget {
  final dynamic onAddNewTaskListButtonPressed;
  final dynamic onAddNewProjectButtonPressed;
  final Widget listView;
  final String firstTaskListName;
  final dynamic onLogInButtonPress;

  HomeScreenHintsMask(
      {Key key,
      this.onAddNewTaskListButtonPressed,
      this.listView,
      this.firstTaskListName,
      this.onAddNewProjectButtonPressed,
      this.onLogInButtonPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var enableStates = EnableStates.of(context).state;
    if (enableStates.showLogInHint) {
      return HintButtonBase(
        text: "You aren't signed in",
        buttonText: "Sign In",
        onPressed: onLogInButtonPress,
      );
    }

    if (enableStates.showSelectAProjectHint) {
      return Container(
        alignment: Alignment.center,
        child: Text('No Project selected'));
    }

    if (enableStates.showNoProjectsHint) {
      return HintButtonBase(
        text: "You haven't created or been invited to any projects yet",
        buttonText: 'Create a project',
        onPressed: onAddNewProjectButtonPressed,
      );
    }

    if (enableStates.showNoTaskListsHint) {
      return NoTaskListsHintButton(
        onPressed: onAddNewTaskListButtonPressed,
      );
    }

    if (enableStates.showSingleListNoTasksHint &&
        listView != null &&
        firstTaskListName != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        listView,
        Expanded(
            child: SingleListNoTasksHint(
          taskListName: firstTaskListName,
        ))
      ]);
    }

    return Container();
  }
}
