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
    return Material(
      type: MaterialType.transparency,
      child: Container(
            color: Theme.of(context).dialogBackgroundColor,
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.title, style: Theme.of(context).textTheme.subtitle),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
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
