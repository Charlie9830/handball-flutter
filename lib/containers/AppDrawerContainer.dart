import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class AppDrawerContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, List<ProjectViewModel>> (
      converter: _converter,
      builder: ( context, projectViewModels) {
        return new AppDrawer(projectViewModels: projectViewModels);
      },
    );
  }

  List<ProjectViewModel> _converter(Store<AppState> store) {
    return store.state.projects.map( (item) {
      return new ProjectViewModel(
        projectModel: item,
        onSelect: ()  { store.dispatch(SelectProject(item.uid)); }
      );
    }).toList();
  }
}
