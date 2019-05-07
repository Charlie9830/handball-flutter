import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class EditableTextInput extends StatefulWidget {
  final String text;
  final bool multiline;
  final dynamic onChanged;

  EditableTextInput({
    this.text,
    this.multiline = false,
    this.onChanged,
  });

  @override
  _EditableTextInputState createState() => _EditableTextInputState();
}

class _EditableTextInputState extends State<EditableTextInput> {
  bool isOpen = false;
  TextEditingController _controller;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return PredicateBuilder(
      predicate: () => isOpen == true,
      childIfTrue: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        autocorrect: true,
        maxLines: widget.multiline ? null : 1,
        textCapitalization: TextCapitalization.sentences,
        onEditingComplete: () => _submit(_controller.text),
      ),
      childIfFalse: InkWell(
          child: Text(widget.text), onTap: () => setState(() => isOpen = true)),
    );
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != isOpen) {
      setState(() => isOpen = _focusNode.hasFocus);
    }
  }

  void _submit(String value) {
    setState(() => isOpen = false);
    widget.onChanged(value);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
