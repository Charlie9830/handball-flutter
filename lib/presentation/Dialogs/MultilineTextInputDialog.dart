import 'package:flutter/material.dart';

class MultilineTextInputDialog extends StatefulWidget {
  final String title;
  final String text;

  MultilineTextInputDialog({
    this.title,
    this.text,
  });

  @override
  MultilineTextInputDialogState createState() =>
      MultilineTextInputDialogState();
}

class MultilineTextInputDialogState extends State<MultilineTextInputDialog> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(_controller.text),
        ),
        title: Text(widget.title),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: null),
      )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
