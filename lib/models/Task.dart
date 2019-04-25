import 'package:meta/meta.dart';

class TaskModel {
    String uid;
    String project;
    String taskList;
    String taskName;
    String dueDate;
    bool isComplete;
    
    TaskModel({@required this.uid, this.taskName, this.dueDate, this.project, this.taskList, this.isComplete});
}

class TaskViewModel {
  final dynamic onSelect;
  final dynamic onCheckboxChanged;

  TaskModel data;

  TaskViewModel({@required this.data, this.onSelect, this.onCheckboxChanged });
}