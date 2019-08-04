import 'package:meta/meta.dart';

class ArchivedProjectModel {
  final String uid;
  final String archivedProjectName;
  final DateTime archivedOn;

  ArchivedProjectModel({
    @required this.uid,
    @required this.archivedProjectName,
    @required this.archivedOn,
  });
}