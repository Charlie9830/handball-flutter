import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class AppDrawerContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppDrawerScreenViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, appDrawerScreenViewModel) {
        return new AppDrawer(viewModel: appDrawerScreenViewModel);
      },
    );
  }

  AppDrawerScreenViewModel _converter(Store<AppState> store, BuildContext context) {
    return new AppDrawerScreenViewModel(
      projectViewModels: _buildProjectViewModels(store, context),
      onAddNewProjectButtonPress: () => store.dispatch(addNewProjectWithDialog(context)),
    );
  }

  List<ProjectViewModel> _buildProjectViewModels(Store<AppState> store, BuildContext context) {
    return store.state.projects.map( (item) {
        return new ProjectViewModel(
          projectName: item.projectName,
          onSelect: () {
             store.dispatch(SelectProject(item.uid));
             store.dispatch(NavigateToProject());
          },
          onDelete: () => store.dispatch(deleteProjectWithDialog(item.uid, item.projectName, context)),
        );
      }).toList();
  }
}
