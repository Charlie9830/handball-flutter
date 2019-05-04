import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';

class TextInputDialog extends StatefulWidget {
  final String text;
  TextInputDialog({this.text});
  
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
                child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
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
              )
            ),
          );
  }

  void _submit(String value, BuildContext context) {
    Navigator.of(context).pop(TextInputDialogResult(result: DialogResult.affirmative, value: value));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}