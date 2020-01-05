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

  // Update copyWith method and fromDefault contructor.

  UserModel(
      {this.isLoggedIn,
      this.email,
      this.userId,
      this.displayName,
      this.playProductId,
      this.playPurchaseDate,
      this.playPurchaseId});

  UserModel.fromDefault() {
    this.isLoggedIn = false;
    this.displayName = '';
    this.userId = '-1';
    this.email = '';
    this.playProductId = '';
    this.playPurchaseDate = null;
    this.playPurchaseId = '';
  }

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

  UserModel copyWith({
    bool isLoggedIn,
    String email,
    String userId,
    String displayName,
    String playPurchaseId,
    DateTime playPurchaseDate,
    String playProductId,
  }) {
    return UserModel(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      playPurchaseId: playPurchaseId ?? this.playProductId,
      playPurchaseDate: playPurchaseDate ?? this.playProductId,
      playProductId: playProductId ?? this.playProductId,
    );
  }
}
