import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/utilities/coerceDate.dart';

class UserModel {
  bool isLoggedIn;
  String email;
  String userId;
  String displayName;
  String playPurchaseId;
  DateTime playPurchaseDate;
  String playProductId;

  UserModel({this.isLoggedIn, this.email, this.userId, this.displayName, this.playProductId, this.playPurchaseDate, this.playPurchaseId});

  UserModel.fromDoc(DocumentSnapshot doc, bool isLoggedIn) {
    this.isLoggedIn = isLoggedIn;
    this.email = doc.data['email'];
    this.userId = doc.documentID;
    this.displayName = doc.data['displayName'];
    this.playProductId = doc.data['playProductId'];
    this.playPurchaseId = doc.data['playPurchaseId'];
    this.playPurchaseDate = coerceDate(doc.data['playPurchaseDate']);
  }

  bool get isPro {
    // TODO: Add IOS Handling for this.
    return this.playPurchaseId != null;
  }

  MemberModel toMember(MemberRole role, MemberStatus status) {
    return MemberModel(
      displayName: this.displayName,
      email: this.email,
      userId: this.userId,
      role: role,
      status: status,
    );
  }
}