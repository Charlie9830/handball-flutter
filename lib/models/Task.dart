import 'package:meta/meta.dart';

class TaskModel {
    String uid;
    String project;
    String taskList;
    String taskName;
    String dueDate;
    bool isComplete;
    
    TaskModel({@required this.uid,
      @required this.project,
      @required this.taskList,
      this.taskName = '',
      this.dueDate = '',
      this.isComplete = false
      });

    Map<String, dynamic> toMap() {
      return {
        'uid': this.uid,
        'project': this.project,
        'taskList': this.taskList,
        'taskName': this.taskName,
        'dueDate': this.dueDate,
        'isComplete': this.isComplete,
      };
    }
}

class TaskViewModel {
  final dynamic onSelect;
  final dynamic onCheckboxChanged;

  TaskModel data;

  TaskViewModel({@required this.data, this.onSelect, this.onCheckboxChanged });
}