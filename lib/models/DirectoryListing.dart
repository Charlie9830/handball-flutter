import 'package:meta/meta.dart';

class DirectoryListing {
  final String email;
  final String displayName;
  final String userId;

  DirectoryListing({
    @required this.email,
    @required this.displayName,
    @required this.userId
  });

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'displayName': this.displayName,
      'userId': this.userId,
    };
  }
}