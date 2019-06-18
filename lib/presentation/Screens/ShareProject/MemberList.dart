import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/presentation/ReactiveAnimatedList.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/MemberListTile.dart';

class MemberList extends StatelessWidget {
  final List<MemberViewModel> viewModels;
  final String title;

  MemberList({
    this.viewModels,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.subtitle),
          ReactiveAnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _getChildren(),
          )
        ],
      ),
    );
  }

  List<MemberListTile> _getChildren() {
    return viewModels.map((vm) {
      return MemberListTile(
        key: Key(vm.data.userId),
        isProcessing: vm.isProcessing,
        displayName: vm.data.displayName,
        email: vm.data.email,
        status: vm.data.status,
        onDemote: vm.onDemote,
        onPromote: vm.onPromote,
        onKick: vm.onKick,
      );
    }).toList();
  }
}
