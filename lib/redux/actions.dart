import 'package:firebase_auth/firebase_auth.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SelectProject {
  final String uid;

  SelectProject(this.uid);
}

class SetUser {
  final User user;

  SetUser({this.user});
}

ThunkAction<AppState> signInUser() {
  return (Store<AppState> store) async {
    print('Signing in User');
    final FirebaseUser user = await auth.signInWithEmailAndPassword(
        email: 'a@test.com', password: 'adingusshrew');

    print('Logged in');
    print('${user.email}  ${user.uid}');

    store.dispatch(SetUser(
        user: new User(
            isLoggedIn: true,
            displayName: user.displayName,
            userId: user.uid,
            email: user.email)
            ));
  };
}
