import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/CloudFunctionLayer.dart';
import 'package:redux/redux.dart';

Future<void> linkAccountToProject(
    Store<AppState> store,
    CloudFunctionsLayer functionsLayer,
    String linkingCode,
    String displayName,
    String email) async {
  try {
    return functionsLayer.linkAccountToProject(
        linkingCode: linkingCode, displayName: displayName, email: email);
  } on CloudFunctionsRejectionError catch (error) {
    // TODO: Add some handling for a rejectionError here. Perhaps asking the user to try the Link again.
  }
}
