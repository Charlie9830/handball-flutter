import 'package:handball_flutter/utilities/coerceDate.dart';

class TaskMetadata {
  String completedBy = '';
  DateTime completedOn;
  String createdBy = '';
  DateTime createdOn;
  String updatedBy = '';
  DateTime updatedOn;

  /*
    REMEMBER TO UPDATE copyWith Method. 
  */

  TaskMetadata({
    this.completedBy,
    this.completedOn,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
  });

  TaskMetadata.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      map = <dynamic, dynamic>{};
    }

    this.completedBy = map['completedBy'] ?? '';
    this.completedOn = coerceDate(map['completedOn']);
    this.createdBy = map['createdBy'] ?? '';
    this.createdOn = coerceDate(map['createdOn']);
    this.updatedBy = map['updatedBy'] ?? '';
    this.updatedOn = coerceDate(map['updatedOn']);
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'completedBy' : this.completedBy,
      'completedOn' : this.completedOn?.toIso8601String() ?? '',
      'createdBy' : this.createdBy,
      'createdOn' : this.createdOn?.toIso8601String() ?? '',
      'updatedBy' : this.updatedBy,
      'updatedOn' : this.updatedOn?.toIso8601String() ?? '',
    };
  }

  TaskMetadata copyWith({
    String completedBy,
    DateTime completedOn,
    String createdBy,
    DateTime createdOn,
    String updatedBy,
    DateTime updatedOn,
  }) {
    return TaskMetadata(
      completedBy: completedBy ?? this.completedBy,
      completedOn: completedOn ?? this.completedOn,
      createdBy: createdBy ?? this.createdBy,
      createdOn: createdOn ?? this.createdOn,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  bool get isAvailable {
    return this.createdBy != null && this.createdOn != null;
  }
}