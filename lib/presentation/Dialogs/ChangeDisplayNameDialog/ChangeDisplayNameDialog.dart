import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Dialogs/ChangeDisplayNameDialog/RequestSuccess.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';
import 'package:handball_flutter/utilities/CloudFunctionLayer.dart';
import 'package:handball_flutter/utilities/showSnackbar.dart';
import 'package:handball_flutter/utilities/validateDisplayName.dart';

class ChangeDisplayNameDialog extends StatefulWidget {
  final String existingValue;
  final String email;
  final CloudFunctionsLayer cloudFunctionsLayer;

  ChangeDisplayNameDialog({
    this.existingValue,
    this.email,
    this.cloudFunctionsLayer,
  });

  @override
  _ChangeDisplayNameDialogState createState() =>
      _ChangeDisplayNameDialogState();
}

class _ChangeDisplayNameDialogState extends State<ChangeDisplayNameDialog> {
  TextEditingController _textController;
  String _errorText;
  bool _isAwaitingRequestCompletion = false;
  bool _didRequestSucceed = false;
  bool _allowSubmit = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController.fromValue(
        TextEditingValue(text: widget.existingValue));

    _textController.addListener(() => {
          setState(() {
            _allowSubmit =
                widget.existingValue.trim() != _textController.text.trim();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleWillPopScope(context),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: SimpleAppBar(),
            body: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: PredicateBuilder(
                  predicate: () => _isAwaitingRequestCompletion == true,
                  maintainState: true,
                  childIfTrue: CircularProgressIndicator(),
                  childIfFalse: PredicateBuilder(
                    predicate: () => _didRequestSucceed == true,
                    childIfTrue: RequestSuccess(
                      newDisplayName: _textController.text.trim(),
                      onFinishButtonPressed: () => _handleFinishButtonPressed(context),),
                    childIfFalse: Column(
                      children: <Widget>[
                        Text(
                            'Changes to your Display Name can take several minutes to propagate and will not apply to events already existing within the Activity Feed.'),
                        TextField(
                          controller: _textController,
                          autofocus: true,
                          onSubmitted: (_) => _handleTextFieldSubmit(),
                          decoration: InputDecoration(
                            hintText: 'Enter a new Display Name',
                            errorText: _errorText,
                          ),
                        ),
                        RaisedButton(
                            child: Text('Submit'),
                            onPressed: _allowSubmit
                                ? () => _handleSubmitButtonPressed(context)
                                : null)
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  void _handleFinishButtonPressed(BuildContext context) async {
    Navigator.of(context).pop(_textController.text.trim());
  }

  Future<bool> _handleWillPopScope(BuildContext context) async {
    if (_isAwaitingRequestCompletion) {
      return false;
    }

    if (_isAwaitingRequestCompletion == false && _didRequestSucceed == true) {
      Navigator.of(context).pop(_textController.text.trim());
      return false;
    }

    return true;
  }

  void _handleSubmitButtonPressed(BuildContext context) {
    final value = _textController.text;
    if (validateDisplayName(value)) {
      _dispatchChangeRequest(context);
    } else {
      setState(() {
        _errorText = 'Display name must be 2 or more characters.';
      });
    }
  }

  void _dispatchChangeRequest(BuildContext context) async {
    setState(() {
      _isAwaitingRequestCompletion = true;
    });

    try {
      await widget.cloudFunctionsLayer.changeDisplayName(
          desiredDisplayName: _textController.text.trim(), email: widget.email);

      print('Sent ${_textController.text.trim()}');

      setState(() {
        _didRequestSucceed = true;
        _isAwaitingRequestCompletion = false;
      });
    } on CloudFunctionsRejectionError catch (e) {
      setState(() {
        _isAwaitingRequestCompletion = false;
      });
      _showSnackBar(context, e.message);
    }
  }

  void _handleTextFieldSubmit() {
    // Validate Field Contents.
    setState(() {
      var s = 'Display name must be 2 or more characters.';
      _errorText =
          validateDisplayName(_textController.text) == false ? s : null;
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  @override
  void dispose() { 
    _textController.dispose();
    super.dispose();
  }
}
