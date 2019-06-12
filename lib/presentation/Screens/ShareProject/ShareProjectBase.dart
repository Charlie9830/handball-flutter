import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/SimplifiedShareProject.dart';

class ShareProjectBase extends StatelessWidget {
  final ShareProjectViewModel viewModel;

  ShareProjectBase({
    @required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return PredicateBuilder(
      predicate: () => viewModel.type == ShareProjectScreenType.simplified,
      childIfTrue: SimplifiedShareProject(viewModel: viewModel),
      childIfFalse: Nothing(),
    );
  }
}
