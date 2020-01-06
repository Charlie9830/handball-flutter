import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/models/AppTheme.dart';

class AccountConfigModel {
  AppThemeModel appTheme;
  bool isDefault = false;

    /* 
  Update copyWith Method Below
  */


  AccountConfigModel({
    this.appTheme,
  });

  AccountConfigModel.fromDefault() {
    this.appTheme = AppThemeModel.fromDefault();
    this.isDefault = true;
  }

  AccountConfigModel.fromDoc(DocumentSnapshot doc) {
    appTheme = AppThemeModel.fromDocMap(doc.data['appTheme']);
  }

  Map<String, dynamic> toMap() {
    return {
      'appTheme' : this.appTheme == null ? null : this.appTheme.toMap(),
    };
  }

  AccountConfigModel copyWith({
    appTheme,
  }) {
    return AccountConfigModel(
      appTheme: appTheme ?? this.appTheme,
    );
  }
}