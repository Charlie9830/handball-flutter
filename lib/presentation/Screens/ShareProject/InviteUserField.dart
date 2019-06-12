import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

class InviteUserField extends StatefulWidget {
  final dynamic onInvite;

  InviteUserField({
    this.onInvite,
  });

  @override
  _InviteUserFieldState createState() => _InviteUserFieldState();
}

class _InviteUserFieldState extends State<InviteUserField> {
  String _emailErrorText;
  TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: SafeArea(
          child: Column(children: <Widget>[
            Text('Share Project', style: Theme.of(context).textTheme.headline),
            TextField(
              controller: _emailController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                errorText: _emailErrorText,
              ),
              onSubmitted: (value) => _submit(context, _emailController.text),
            ),
            RaisedButton(
              child: Text('Invite'),
              onPressed: () => _submit(context, _emailController.text)
            )
          ],)
        )
      )
    );
  }

  void _submit(BuildContext context, String email) {
    if (!isValidEmail(email)) {
      // Invalid Email.
      setState( () => _emailErrorText = 'Invalid email');
      return;
    }

    setState( () => _emailErrorText = null);

    widget.onInvite(_emailController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }
}