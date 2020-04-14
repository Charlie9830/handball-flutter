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
  static const _kickUserFromProjectFunctionName = 'kickUserFromProject';
  static const _removeRemoteProjectFunctionName = 'removeRemoteProject';
  static const _changeDisplayNameFunctionName = 'changeDisplayName';
  static const _changeEmailAddressFunctionName = 'changeEmailAddress';
  static const _sendAppAndProjectInviteFunctionName = 'sendAppAndProjectInvite';
  static const _linkAccountToProjectFunctionName = 'linkAccountToProject';

  Future<void> linkAccountToProject({
    @required String linkingCode,
    @required String displayName,
    @required String email,
  }) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: _linkAccountToProjectFunctionName);

    try {
      final response = await callable.call({
        'linkingCode': linkingCode,
        'displayName': displayName,
        'email': email,
      });

      if (response.data['status'] == 'complete') {
        return;
      }

      if (response.data['status'] == 'error') {
        throw CloudFunctionsRejectionError(message: response.data['message']);
      }
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
    }
  }


  Future<void> changeEmailAddress({
    @required String oldEmail,
    @required String newEmail,
  }) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _changeEmailAddressFunctionName);

    try {
      final response = await callable.call({
        'newEmailAddress': newEmail,
        'oldEmailAddress': oldEmail,
      });

      if (response.data['status'] == 'complete') {
        return;
      }

      if (response.data['status'] == 'error') {
        throw CloudFunctionsRejectionError(message: response.data['message']);
      }
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
    }
  }

  Future<void> changeDisplayName({
    @required String desiredDisplayName,
    @required String email,
  }) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _changeDisplayNameFunctionName);

    try {
      final response = await callable.call({
        'desiredDisplayName': desiredDisplayName,
        'email': email,
      });

      if (response.data['status'] == 'complete') {
        return;
      }

      if (response.data['status'] == 'error') {
        throw CloudFunctionsRejectionError(message: response.data['message']);
      }
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
    }
  }

  Future<void> removeRemoteProject({
    @required String projectId,
  }) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _removeRemoteProjectFunctionName);

    try {
      var response = await callable.call({
        'projectId': projectId,
      });

      if (response.data['status'] == 'complete') {
        return;
      }

      if (response.data['status'] == 'error') {
        throw CloudFunctionsRejectionError(message: response.data['message']);
      }
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
    }
  }

  Future<void> kickUserFromProject({
    @required String userId,
    @required String projectId,
  }) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: _kickUserFromProjectFunctionName);

    try {
      var response = await callable.call({
        'userId': userId,
        'projectId': projectId,
      });

      if (response.data['status'] == 'complete') {
        return;
      }

      if (response.data['status'] == 'error') {
        throw CloudFunctionsRejectionError(
          message: response.data['message'],
        );
      }
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
    }
  }

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
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
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
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
    }
  }

  Future<void> sendAppAndProjectInvite({
    @required String projectName,
    @required String projectId,
    @required String sourceDisplayName,
    @required String targetEmail,
  }) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: _sendAppAndProjectInviteFunctionName);

    try {
      final response = await callable.call(<String, dynamic>{
        'projectName': projectName,
        'projectId': projectId,
        'sourceDisplayName': sourceDisplayName,
        'targetEmail': targetEmail
      });

      if (response.data['status'] == null) {
        throw CloudFunctionsRejectionError(message: 'sendAppAndProjectInvite failed. Response status returned null');
      }

      if (response.data['status'] == 'error') {
        print('Cloud Function returned an Error');
        print(response.data['message']);
      }
      // TODO: Implement proper response handling.
    } on CloudFunctionsException catch(error) {
      // TODO: Implement proper error handling.
      print(error.message);
      
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
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
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
    } on CloudFunctionsException catch (error) {
      _handleCloudFunctionsException(error);
    }
  }

  void _handleCloudFunctionsException(CloudFunctionsException error) {
    if (error.code == 'INTERNAL') {
      // TODO: Could this be a specific no Connection error?
      throw CloudFunctionsRejectionError(
          message:
              'Could not contact server, please check your internet connection.');
    }
  }
}

class CloudFunctionsRejectionError extends Error {
  final String message;

  CloudFunctionsRejectionError({
    this.message = 'No error message was provided from server',
  });

  @override
  String toString() {
    return message;
  }
}
