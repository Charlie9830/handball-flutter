import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/utilities/showSnackbar.dart';

String getAuthExceptionFriendlyMessage(PlatformException error) {
  switch (error.code) {
    case 'ERROR_INVALID_EMAIL':
      return 'Make sure you email address is valid.';

    case 'ERROR_USER_NOT_FOUND':
      return 'Account not found.';

    case 'ERROR_WRONG_PASSWORD':
      return 'That password does not match the account.';

    default:
      return 'Oops, something went wrong.';
  }
}

void handleAuthException(
    PlatformException error, GlobalKey<ScaffoldState> scaffoldKey) {
      // TODO: Log the extended error details to a Logging service.

      showSnackBar(message: getAuthExceptionFriendlyMessage(error), targetGlobalKey: scaffoldKey);
}
