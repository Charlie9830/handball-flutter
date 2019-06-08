import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/models/DirectoryListing.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/DecorationPainter.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/NavigationButtons.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/Result.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

// Be very careful about reordering these Enums. This widget should honor the order of this enum, but there is still
// something somewhere that doesn't honor it correctly.
// TODO: Fix above. Start with maxUserIndex referenceing displayName directly instead of result.index - 1.
enum SignUpSteps { email, password, displayName, result }

final int maxIndex = SignUpSteps.values.length - 1;
final SignUpSteps maxUserStep = SignUpSteps
    .displayName; // Max Index user can reach, above this it is programatically controlled.
final int resultIndex = SignUpSteps.result.index;

class SignUpBase extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  final Firestore firestore;

  SignUpBase({
    @required this.firebaseAuth,
    @required this.firestore,
  });

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
  String _passwordErrorText;
  String _displayNameErrorText;

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
      initialIndex: SignUpSteps.values[0].index,
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
                        children: _getStepContents(context),
                      ),
                    ),
                  ),
                  PredicateBuilder(
                    predicate: () =>
                        _tabController.index != SignUpSteps.result.index,
                    childIfTrue: NavigationButtons(
                      leftButtonText: 'Back',
                      rightButtonText: 'Next',
                      onRightButtonPressed: () => _moveNext(context),
                      onLeftButtonPressed: () => _movePrev(context),
                    ),
                    childIfFalse: Nothing(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getStepContents(BuildContext context) {
    return SignUpSteps.values.map((value) {
      switch (value) {
        case SignUpSteps.email:
          return TextField(
            decoration: InputDecoration(
              labelText: 'Email address',
              errorText: _emailErrorText,
            ),
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            onSubmitted: (value) => _moveNext(context),
          );

        case SignUpSteps.password:
          return TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _passwordErrorText,
            ),
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: true,
            keyboardType: TextInputType.text,
            onSubmitted: (value) => _moveNext(context),
          );

        case SignUpSteps.displayName:
          return TextField(
            controller: _displayNameController,
            focusNode: _displayNameFocusNode,
            decoration: InputDecoration(
              labelText: 'Display name',
              errorText: _displayNameErrorText,
            ),
            onSubmitted: (value) => _moveNext(context),
          );

        case SignUpSteps.result:
          return Result(
            result: result,
            message: resultMessage,
            onBackButtonPressed: () => _movePrev(context),
            onStartButtonPressed: () => _finish(context),
          );

        default:
          throw UnimplementedError(
              'Switch case does not exist for this SignUpStep value: $value');
      }
    }).toList();
  }

  bool _isValidPassword(String password) {
    if (password == null) {
      return false;
    }

    return password.length >= 6;
  }

  void _moveNext(BuildContext context) {
    SignUpSteps currentStep = SignUpSteps.values[_tabController.index];

    // Validate Email Address.
    if (currentStep == SignUpSteps.email &&
        !isValidEmail(_emailController.text)) {
      setState(() => _emailErrorText = 'Invalid email');
      return;
    }

    setState(() => _emailErrorText = null);

    // Validate Password.
    if (currentStep == SignUpSteps.password &&
        !_isValidPassword(_passwordController.text)) {
      // Invalid Password.
      setState(() => _passwordErrorText =
          'Please use a password with at least 6 characters');
      return;
    }

    setState(() => _passwordErrorText = null);

    // Validate Display Name.
    if (currentStep == SignUpSteps.displayName &&
        !_isValidDisplayName(_displayNameController.text)) {
      // Invalid Display Name.
      setState(() => _displayNameErrorText =
          'Please use a Display Name with at least 2 characters');
      return;
    }

    setState(() => _displayNameErrorText = null);

    if (currentStep != maxUserStep) {
      // Step Next.
      var newIndex = _tabController.index + 1;
      _tabController.index = newIndex;
    }

    else {
      // Try to Register (Takes us to result page).
      _tryRegister();
    }
  }

  void _finish(BuildContext context) {
    Navigator.of(context).pop();
  } 

  void _dropKeyboardFocus() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _displayNameFocusNode.unfocus();
  }

  void _tryRegister() async {
    _dropKeyboardFocus();

    var email = _emailController.text;
    var password = _passwordController.text;
    var displayName = _displayNameController.text;

    setState(() => result = SignUpResult.indeterminate);
    _tabController.index = resultIndex;

    try {
      var user = await widget.firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserUpdateInfo profileUpdateInfo = new UserUpdateInfo();
      profileUpdateInfo.displayName = displayName;

      List<Future> requests = [];
      requests.add(user.updateProfile(profileUpdateInfo));
      requests.add(widget.firestore
          .collection('directory')
          .document(email)
          .setData(DirectoryListing(
                  displayName: displayName, email: email, userId: user.uid)
              .toMap()));

      await Future.wait(requests);

      _showResultPage(SignUpResult.success,
          'Welcome $displayName, you are all ready to go, lets get started!');
    } catch (error) {
      if (error is PlatformException) {
        _showResultPage(
            SignUpResult.error, _getHumanFriendlyErrorText(error.code));
      }

      // TODO: Add handling here for if something goes wrong whilst updating the UserProfile or creating the directory Listing.
      // User account should be cleaned up (Deleted), and user sent back to try again.
      else {
        throw error;
      }
      
    }
  }

  bool _isValidDisplayName(String displayName) {
    return displayName != null && displayName.length > 1;
  }

  String _getHumanFriendlyErrorText(String errorCode) {
    if (errorCode == 'ERROR_EMAIL_ALREADY_IN_USE') {
      return 'The email address you entered is already registered';
    }

    if (errorCode == 'ERROR_WEAK_PASSWORD') {
      return 'Password is too weak, try using a password with at least 6 characters';
    }

    return 'An unknown error has occured. Please try again';
  }

  void _showResultPage(SignUpResult signUpResult, String message) {
    setState(() {
      result = signUpResult;
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
    if (index == SignUpSteps.email.index) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    }

    if (index == SignUpSteps.password.index) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    }

    if (index == SignUpSteps.displayName.index) {
      FocusScope.of(context).requestFocus(_displayNameFocusNode);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

    _emailController.dispose();
    _emailFocusNode.dispose();

    _passwordController.dispose();
    _passwordFocusNode.dispose();

    _displayNameController.dispose();
    _displayNameFocusNode.dispose();

    super.dispose();
  }
}
