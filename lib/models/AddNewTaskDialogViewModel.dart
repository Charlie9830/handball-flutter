import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/TaskList.dart';

class AddNewTaskDialogViewModel {
  final TaskListModel preSelectedTaskList;
  final List<TaskListModel> taskLists;
  final String favirouteTaskListId;
  final List<Assignment> assignmentOptions;
  final Map<String, MemberModel> memberLookup;
  final bool isProjectShared;
  
  
  AddNewTaskDialogViewModel({
    this.preSelectedTaskList,
    this.taskLists,
    this.favirouteTaskListId,
    this.assignmentOptions,
    this.memberLookup,
    this.isProjectShared,
  });
}