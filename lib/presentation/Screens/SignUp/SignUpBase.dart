import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/DecorationPainter.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/NavigationButtons.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/Result.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

const int maxIndex = 3;
const int maxUserIndex =
    2; // Max Index user can reach, above this it is programatically controlled.
const int minStep = 0;
const int resultIndex = 3;

class SignUpBase extends StatefulWidget {
  @override
  _SignUpBaseState createState() => _SignUpBaseState();
}

class _SignUpBaseState extends State<SignUpBase> with TickerProviderStateMixin {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _displayNameController;

  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _displayNameFocusNode;

  String _emailErrorText;

  TabController _tabController;

  SignUpResult result = SignUpResult.indeterminate;
  String resultMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _displayNameController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _displayNameFocusNode = FocusNode();
    _tabController = TabController(
      length: maxIndex + 1,
      vsync: this,
      initialIndex: 0,
    );

    _tabController.addListener(() {
      // Ensure that focus is automatically granted to whichever Tab we just changed to.
      // Waiting for 250ms before grabbingFocus allows the animation to complete (I beleive),
      // otherwise it does not grab keyboard focus.
      Future.delayed(Duration(milliseconds: 250),
          () => _grabFocus(context, _tabController.index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: CustomPaint(
          painter: DecorationPainter(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  8, 16, 8, MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Create Account',
                          style: Theme.of(context).textTheme.headline),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      alignment: Alignment.center,
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Email address',
                              errorText: _emailErrorText,
                            ),
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: true,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                          ),
                          TextField(
                            controller: _displayNameController,
                            focusNode: _displayNameFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Display name',
                            ),
                          ),
                          Result(
                            result: result,
                            message: resultMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  NavigationButtons(
                    leftButtonText: 'Back',
                    rightButtonText: 'Next',
                    onRightButtonPressed: () => _moveNext(context),
                    onLeftButtonPressed: () => _movePrev(context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _moveNext(BuildContext context) {
    if (_tabController.index < maxIndex - 1) {
      // Don't allow the user to Step into the Result Page.
      if (_tabController.index == 0 && !isValidEmail(_emailController.text)) {
        // Invalid Email
        setState(() => _emailErrorText = 'Invalid email');
        return;
      }

      setState(() => _emailErrorText = null);

      var newIndex = _tabController.index + 1;
      _tabController.index = newIndex;
    }

    else if (_tabController.index == maxUserIndex) {
      _tryRegister();
    }
  }

  void _tryRegister() async {
    setState(() => result = SignUpResult.indeterminate);

    try {
      print("Dispatching createUserWithEmailAndPassword");
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      print("Completed");

      _showResultPage(
          SignUpResult.success, 'You are all ready to go, lets get started!');
    } catch (error) {
      if (error is PlatformException) {
        var message = error.message ?? 'No message provided';
        _showResultPage(SignUpResult.error, message);
      }
    }
  }

  void _showResultPage(SignUpResult result, String message) {
    setState(() {
      result = result;
      resultMessage = message;
    });

    _tabController.index = resultIndex;
  }

  void _movePrev(BuildContext context) {
    if (_tabController.index >= 1) {
      var newIndex = _tabController.index - 1;
      _tabController.index = newIndex;
    } else {
      Navigator.of(context).pop();
    }
  }

  void _grabFocus(BuildContext context, int index) async {
    if (index == 0) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    }

    if (index == 1) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    }

    if (index == 2) {
      FocusScope.of(context).requestFocus(_displayNameFocusNode);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();

    super.dispose();
  }
}
