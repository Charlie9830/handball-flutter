import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/EditableTextInput.dart';

class CommentInput extends StatefulWidget {
  final dynamic onPost;
  CommentInput({Key key, this.onPost}) : super(key: key);

  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _textEditingController,
            autofocus: true,
            minLines: 1,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            onSubmitted: (_) => _postComment(_textEditingController.text),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              filled: true,
              fillColor: Theme.of(context).cardColor,

            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_comment),
          onPressed: () => _postComment(_textEditingController.text),
          iconSize: 32,
        )
      ],
    ));
  }

  void _postComment(String value) {
    widget.onPost(value);
    _textEditingController.text = '';
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
