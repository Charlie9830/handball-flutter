import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final bool isOpen;
  final String text;
  final onOkay;
  final onCancel;

  TextInputDialog({this.isOpen, this.text, this.onOkay, this.onCancel});
  
  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  String _newValue = '';
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(() =>  setState( () => _newValue = _controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
          visible: widget.isOpen,
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
                        onPressed: () => widget.onOkay(_newValue),
                      ),
                ],
              ),
            )
          ),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}