import 'package:meta/meta.dart';

class ProjectIdModel {
  final String uid;

  
  ProjectIdModel({
    @required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
    };
  }
}