import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Dialogs/MultilineTextInputDialog.dart';
import 'package:handball_flutter/presentation/EditableTextInput.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:intl/intl.dart';

class NoteInputListItem extends StatelessWidget {
  final String note;
  final String taskName;
  final dynamic onChange;

  NoteInputListItem({
    this.taskName,
    this.note,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.note_add),
        title: note.trim().isEmpty ? Text('Add details') : Text(note),
        onTap: () => _handleTap(context));
  }

  void _handleTap(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return MultilineTextInputDialog(
          title: taskName,
          text: note,
        );
      },
      barrierDismissible: false,
    );

    // If showDialog returned Null, that means user pressed Android Back button, so discard there changes.
    // TODO: Re implement this so even if the user presses the Android back button, they wont loose the changes.
    // Could use a callback to save the result outside the showDialog call.
    onChange(result ?? note);
  }
}
