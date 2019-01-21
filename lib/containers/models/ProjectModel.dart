import 'package:meta/meta.dart';

class ProjectModel {
    String uid;
    String name;
  
    ProjectModel({@required this.uid, this.name});
  }

class ProjectViewModel extends ProjectModel {
  final dynamic onSelect;

  ProjectViewModel({@required projectModel, this.onSelect }) {
    super.uid = projectModel.uid;
    super.name = projectModel.name;
  }
}