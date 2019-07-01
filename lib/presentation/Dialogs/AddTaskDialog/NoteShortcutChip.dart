import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Dialogs/MultilineTextInputDialog.dart';

class NoteShortcutChip extends StatelessWidget {
  final String note;
  final EdgeInsetsGeometry padding;
  final dynamic onChanged;
  const NoteShortcutChip({Key key, this.note, this.onChanged, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ActionChip(
          avatar: Icon(
            Icons.note,
            size: 18,
          ),
          label: SizedBox(
              width: 75.0,
              child: Text(
                note ?? 'Details',
                overflow: TextOverflow.ellipsis,
              )),
          onPressed: () => _handleOnPressed(context)),
    );
  }

  void _handleOnPressed(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) => MultilineTextInputDialog(
            text: note,
            title: 'Add details',
          ),
    );

    if (result is String) {
      onChanged(result);
    }
  }
}
