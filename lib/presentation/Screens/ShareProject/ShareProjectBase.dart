import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/ComplexShareProject.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/SimplifiedShareProject.dart';

class ShareProjectBase extends StatelessWidget {
  final ShareProjectViewModel viewModel;

  ShareProjectBase({
    @required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: SafeArea(
        child: Scaffold(
          key: shareScreenScaffoldKey,
          appBar: AppBar(
            title: viewModel.type == ShareProjectScreenType.simplified
                ? Text('Share Project')
                : Text('Manage Sharing'),
          ),
          body: PredicateBuilder(
            predicate: () =>
                viewModel.type == ShareProjectScreenType.simplified,
            childIfTrue: SimplifiedShareProject(viewModel: viewModel),
            childIfFalse: ComplexShareProject(viewModel: viewModel),
          ),
        ),
      ),
    );
  }
}
