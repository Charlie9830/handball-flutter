import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

class InviteUserField extends StatefulWidget {
  final bool isInvitingUser;
  final bool autofocus;
  final dynamic onInvite;

  InviteUserField({
    this.isInvitingUser = false,
    this.autofocus = false,
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
    return SizedBox(
      height: 130,
      child: Container(
          padding: EdgeInsets.all(8),
          child: PredicateBuilder(
            predicate: () => widget.isInvitingUser,
            childIfTrue: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator()],
            ),
            childIfFalse: Column(
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    errorText: _emailErrorText,
                  ),
                  onSubmitted: (value) =>
                      _submit(context, _emailController.text),
                ),
                RaisedButton(
                    child: Text('Invite'),
                    onPressed: () => _submit(context, _emailController.text))
              ],
            ),
          )),
    );
  }

  void _submit(BuildContext context, String email) {
    if (!isValidEmail(email)) {
      // Invalid Email.
      setState(() => _emailErrorText = 'Invalid email');
      return;
    }

    setState(() => _emailErrorText = null);

    widget.onInvite(_emailController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }
}
