import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AppSettings.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/ShareProjectBase.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class ShareProjectContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ShareProjectViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, viewModel) {
        return new ShareProjectBase(viewModel: viewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return ShareProjectViewModel(
      projectEntity: store.state.projectShareMenuEntity,
      type: ShareProjectScreenType.simplified,
      onInvite: (email) => store.dispatch(inviteUserToProject(
          email,
          store.state.projectShareMenuEntity.uid,
          store.state.projectShareMenuEntity.projectName,
          MemberRole.member)),
    );
  }
}
