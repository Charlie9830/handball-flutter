import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/UpgradeToProDialogContainer.dart';
import 'package:handball_flutter/presentation/Dialogs/UpgradeToProDialog/UpgradeToProDialog.dart';

class UpgradeToProButton extends StatelessWidget {
  const UpgradeToProButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _handleTap(context),
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: <Widget>[
              Icon(
                Icons.new_releases,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: Text("Upgrade to Pro",
                    style: TextStyle(
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ));
  }

  void _handleTap(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => UpgradeToProDialogContainer(),
    );
  }
}
