import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/presentation/Dialogs/DelegateOwnerDialog/DelegateOwnerDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';

Future<String> postDelegateOwnerDialog(
    List<MemberModel> nonOwnerMembers, BuildContext context) {
  // Returns userId of selected user or null if User cancelled dialog.
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DelegateOwnerDialog(members: nonOwnerMembers);
      });
}

Future<TextInputDialogResult> postTextInputDialog(
    String title, String text, BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => TextInputDialog(title: title, text: text),
  );
}

Future<DialogResult> postConfirmationDialog(String title, String text,
    String affirmativeText, String negativeText, BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text(negativeText),
                onPressed: () =>
                    Navigator.of(context).pop(DialogResult.negative),
              ),
              FlatButton(
                child: Text(affirmativeText),
                onPressed: () =>
                    Navigator.of(context).pop(DialogResult.affirmative),
              ),
            ]);
      });
}

Future<void> postAlertDialog(
    String title, String text, String affirmativeText, BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text(affirmativeText),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ]);
      });
}
