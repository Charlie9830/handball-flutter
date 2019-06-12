import 'package:meta/meta.dart';

class DirectoryListing {
  String email;
  String displayName;
  String userId;

  DirectoryListing({
    @required this.email,
    @required this.displayName,
    @required this.userId
  });

  DirectoryListing.fromMap(Map<dynamic, dynamic> map) {
    this.email = map['email'];
    this.displayName = map['displayName'];
    this.userId = map['userId'];
  }
  

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'displayName': this.displayName,
      'userId': this.userId,
    };
  }
}