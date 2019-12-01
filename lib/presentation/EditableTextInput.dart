import 'package:flutter/material.dart';

class EditableTextInput extends StatefulWidget {
  final String text;
  final String hintText;
  final bool isMultiline;
  final bool autofocus;
  final TextStyle style;
  final dynamic onChanged;

  EditableTextInput({
    this.text = '',
    this.hintText = '',
    this.onChanged,
    this.isMultiline,
    this.style,
    this.autofocus,
  });

  @override
  _EditableTextInputState createState() => _EditableTextInputState();
}

class _EditableTextInputState extends State<EditableTextInput> {
  bool isOpen = false;
  TextEditingController _controller;
  FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _focusNode.addListener(_handleFocusChange);
    
  }

  @override
  Widget build(BuildContext context) {
      return TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: isOpen ? InputDecoration() : InputDecoration.collapsed(hintText: widget.hintText),
        autocorrect: true,
        autofocus: widget.autofocus ?? false,
        keyboardType: widget.isMultiline == null || widget.isMultiline == false ?
         TextInputType.text : TextInputType.multiline, // Allows for Wrapping without becoming truly multiline, ie: Swapping the done button for the Carriage Return
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        onEditingComplete: () => _submit(_controller.text),
        style: widget.style,
      );
  }

  void _handleFocusChange() {
      setState(() => isOpen = _focusNode.hasFocus);
  }

  void _submit(String value) {
    // setState(() => isOpen = false);
    _focusNode.unfocus();
    widget.onChanged(value);
  }

  @override
  dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
