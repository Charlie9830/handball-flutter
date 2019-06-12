import 'package:cloud_functions/cloud_functions.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/DirectoryListing.dart';
import 'package:handball_flutter/utilities/convertMemberRole.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';
import 'package:meta/meta.dart';

class CloudFunctionsLayer {
  static const _getRemoteUserDataFunctionName = 'getRemoteUserData';
  static const _sendProjectInviteFunctionName = 'sendProjectInvite';
  static const _acceptProjectInviteFunctionName = 'acceptProjectInvite';
  static const _denyProjectInviteFunctionName = 'denyProjectInvite';

  Future<void> acceptProjectInvite({
    @required String projectId,
  }) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _acceptProjectInviteFunctionName);

    try {
      var response =
          await callable.call(<String, dynamic>{'projectId': projectId});

      if (response.data['status'] == 'complete') {
        return;
      }

      if (response.data['status'] == 'error') {
        throw CloudFunctionsRejectionError(
            message:
                'acceptProjectInvite failed. Message from server: ${response.data['message']}');
      }

      if (response.data['status'] == null) {
        throw CloudFunctionsRejectionError(
            message:
                'acceptProjectInvite failed. Response status returned null');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> denyProjectInvite({
    @required String projectId,
  }) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _denyProjectInviteFunctionName);

    try {
      var response =
          await callable.call(<String, dynamic>{'projectId': projectId});

      if (response.data['status'] == 'complete') {
        return;
      }

      if (response.data['status'] == 'error') {
        throw CloudFunctionsRejectionError(
            message:
                'denyProjectInvite failed. Message from server: ${response.data['message']}');
      }

      if (response.data['status'] == null) {
        throw CloudFunctionsRejectionError(
            message: 'denyProjectInvite failed. Response status returned null');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> sendProjectInvite({
    @required String projectName,
    @required String sourceEmail,
    @required String sourceDisplayName,
    @required String projectId,
    @required String targetUserId,
    @required String targetDisplayName,
    @required String targetEmail,
    @required MemberRole role,
  }) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _sendProjectInviteFunctionName);

    try {
      var response = await callable.call(<String, dynamic>{
        'projectName': projectName,
        'sourceEmail': sourceEmail,
        'sourceDisplayName': sourceDisplayName,
        'projectId': projectId,
        'targetUserId': targetUserId,
        'targetDisplayName': targetDisplayName,
        'targetEmail': targetEmail,
        'role': convertMemberRole(role),
      });

      if (response.data['status'] == 'complete') {
        return;
      } else {
        throw CloudFunctionsRejectionError(message: response.data['error']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<DirectoryListing> getRemoteUserData(String targetEmail) async {
    if (targetEmail == null ||
        targetEmail == '' ||
        isValidEmail(targetEmail) == false) {
      throw UnsupportedError(
          'targetEmail address format is unsupported. targetEmail: $targetEmail');
    }

    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _getRemoteUserDataFunctionName);
    try {
      var response =
          await callable.call(<String, dynamic>{'targetEmail': targetEmail});

      if (response.data['status'] == 'user not found') {
        return null;
      }

      return DirectoryListing.fromMap(response.data['userData']);
    } catch (error) {
      throw error;
    }
  }
}

class CloudFunctionsRejectionError extends Error {
  final String message;

  CloudFunctionsRejectionError({
    this.message = 'No error message was provided from server',
  });
}
