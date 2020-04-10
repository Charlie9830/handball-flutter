import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/Nothing.dart';

class StatusText extends StatelessWidget {
  final MemberStatus status;

  StatusText({
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MemberStatus.pending:
        return Text('Invite sent', style: TextStyle(color: Colors.amber));

      case MemberStatus.added:
        return Text('Added', style: TextStyle(color: Colors.green));

      case MemberStatus.denied:
        return Text('Declined');

      default:
        return Nothing();
    }
  }
}
