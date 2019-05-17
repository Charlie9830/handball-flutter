import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String text;
  TextInputDialog({
    this.title,
    this.text,
  });

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Theme.of(context).dialogBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.title,
                            style: Theme.of(context).textTheme.subtitle),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            keyboardAppearance: Theme.of(context).brightness,
                            onEditingComplete: () => _submit(_controller.text, context),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _submit(_controller.text, context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(String value, BuildContext context) {
    Navigator.of(context).pop(
        TextInputDialogResult(result: DialogResult.affirmative, value: value));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
