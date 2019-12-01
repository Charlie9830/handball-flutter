import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/CommentPanel/CommentPanel.dart';
import 'package:handball_flutter/presentation/EditableTextInput.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/NoTaskEntityFallback.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskPropertiesCard.dart';
import 'package:handball_flutter/presentation/TaskMetadataListItem/TaskMetadataExpansionTile.dart';

class TaskInspectorScreen extends StatelessWidget {
  final TaskInspectorScreenViewModel viewModel;

  TaskInspectorScreen({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _handleWillPopScope,
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: viewModel.onClose),
                    IconButton(
                        icon: viewModel.taskEntity.isHighPriority
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        onPressed: viewModel.onIsHighPriorityChange)
                  ]),
            ),
            body: SingleChildScrollView(   
              child: PredicateBuilder(
                predicate: () => viewModel.taskEntity != null,
                childIfTrue: Container(
                    child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 24, right: 8, bottom: 24),
                            child: EditableTextInput(
                                text: viewModel.taskEntity.taskName,
                                hintText: 'Task Name',
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                ),
                                onChanged: viewModel.onTaskNameChange),
                          ),
                        ),
                      ]),
                  TaskPropertiesCard(
                    dueDate: viewModel.taskEntity.dueDate,
                    onDueDateChange: viewModel.onDueDateChange,
                    reminder: viewModel.taskEntity.ownReminder?.time,
                    enableReminder: viewModel.taskEntity.isComplete == false,
                    onReminderChange: viewModel.onReminderChange,
                    note: viewModel.taskEntity.note,
                    onNoteChange: viewModel.onNoteChange,
                    taskName: viewModel.taskEntity.taskName,
                    assignmentOptions: viewModel.assignmentOptions,
                    assignments: viewModel.assignments,
                    onAssignmentsChange: viewModel.onAssignmentsChange,
                    isAssignmentInputVisible: viewModel.isAssignmentInputVisible,
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 280,
                        child: CommentPanel(
                            isInteractive: false,
                            onPressed: viewModel.onOpenTaskCommentScreen,
                            viewModels: viewModel.commentPreviewViewModels)),
                  )),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TaskMetadataExpansionTile(
                      metadata: viewModel.taskEntity.metadata,
                    ),
                  ))
                ])),
                childIfFalse: NoTaskEntityFallback(),
              ),
            ),
          ),
        ));
  }

  Future<bool> _handleWillPopScope() {
    // Intercept a "Back Button Press", dispatch the onClose event then block the Pop Action from occuring so that the Navigation
    // Middleware can handle the Pop itself. Otherwise you will 'Pop Twice' back 2 routes.

    viewModel.onClose();
    return Future.value(false);
  }
}
