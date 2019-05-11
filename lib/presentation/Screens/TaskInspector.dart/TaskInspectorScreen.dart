import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/EditableTextInput.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/NoTaskEntityFallback.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskPropertiesCard.dart';

class TaskInspectorScreen extends StatelessWidget {
  final TaskInspectorScreenViewModel viewModel;

  TaskInspectorScreen({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPopScope,
      child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: PredicateBuilder(
              predicate: () => viewModel.taskEntity != null,
              childIfTrue: Container(
                  child: Column(children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: viewModel.onClose
                      ),
                      IconButton(
                        icon: viewModel.taskEntity.isHighPriority ? Icon(Icons.star) : Icon(Icons.star_border),
                        onPressed: viewModel.onIsHighPriorityChange
                        )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, top: 24, right: 8, bottom: 24),
                          child: EditableTextInput(
                              text: viewModel.taskEntity.taskName,
                              hintText: 'Task Name',
                              onChanged: viewModel.onTaskNameChange),
                        ),
                      ),
                    ]),
                TaskPropertiesCard(
                  dueDate: viewModel.taskEntity.dueDate,
                  onDueDateChange: viewModel.onDueDateChange,
                  note: viewModel.taskEntity.note,
                  onNoteChange: viewModel.onNoteChange,
                  taskName: viewModel.taskEntity.taskName,
                )
              ])),
              childIfFalse: NoTaskEntityFallback(),
            ),
          )),
    );
  }

  Future<bool> _handleWillPopScope() {
    // Intercept a "Back Button Press", dispatch the onClose event then block the Pop Action from occuring so that the Navigation
    // Middleware can handle the Pop itself. Otherwise you will 'Pop Twice' back 2 routes.

    viewModel.onClose();
    return Future.value(false);
  }
}
