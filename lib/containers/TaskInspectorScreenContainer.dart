import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class TaskInspectorScreenContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, TaskInspectorScreenViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, taskInspectorScreenViewModel) {
        return new TaskInspectorScreen(viewModel: taskInspectorScreenViewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new TaskInspectorScreenViewModel(
      onClose: () => store.dispatch(CloseTaskInspector()),
      taskEntity: store.state.selectedTaskEntity,
      onDueDateChange: (newValue) => store.dispatch(updateTaskDueDate(store.state.selectedTaskEntity.uid, newValue))
    );
  }
}
