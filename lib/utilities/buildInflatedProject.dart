import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/InflatedTaskList.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:meta/meta.dart';

InflatedProjectModel buildInflatedProject(
    {@required List<TaskModel> tasks,
    @required List<TaskListModel> taskLists,
    @required ProjectModel project,
    @required TaskListSorting listSorting,
    @required List<String> listCustomSortOrder,
    @required bool showOnlySelfTasks}) {
  if (project == null) {
    return null;
  }

  var sortedTaskLists =
      _sortTaskLists(listSorting, taskLists, listCustomSortOrder);

  var taskFilter = showOnlySelfTasks == true
      ? (TaskModel task, String taskListId) =>
          task.taskList == taskListId && task.isAssignedToSelf == true
      : (TaskModel task, String taskListId) => task.taskList == taskListId;

  var inflatedTaskLists = sortedTaskLists
      .where((taskList) => taskList.project == project.uid)
      .map((taskList) {
    return InflatedTaskListModel(
      data: taskList,
      tasks: _sortTasks(tasks.where((task) => taskFilter(task, taskList.uid)),
          taskList.settings.sortBy),
    );
  }).toList();

  return InflatedProjectModel(
      data: project,
      taskListSorting: listSorting,
      inflatedTaskLists: inflatedTaskLists,
      taskIndices: _buildTaskIndices(inflatedTaskLists));
}

List<TaskModel> _sortTasks(Iterable<TaskModel> tasks, TaskSorting sorting) {
  switch (sorting) {
    case TaskSorting.completed:
      return List.from(tasks)..sort(_taskSorterCompleted);

    case TaskSorting.priority:
      return List.from(tasks)..sort(_taskSorterPriority);

    case TaskSorting.dueDate:
      return List.from(tasks)..sort(_taskDueDateSorter);

    case TaskSorting.dateAdded:
      return List.from(tasks)..sort(_taskDateAddedSorter);

    case TaskSorting.assignee:
      return List.from(tasks)..sort(_taskAssigneeSorter);

    case TaskSorting.alphabetically:
      return List.from(tasks)..sort(_taskSorterAlphabetical);

    default:
      return List.from(tasks);
  }
}

int _taskSorterAlphabetical(TaskModel a, TaskModel b) {
  return a.taskName.toUpperCase().compareTo(b.taskName.toUpperCase());
}

int _taskSorterCompleted(TaskModel a, TaskModel b) {
  if (a.isComplete) {
    return 1;
  }
  if (b.isComplete) {
    return -1;
  } else {
    return _taskDateAddedSorter(a, b);
  }
}

int _taskSorterPriority(TaskModel a, TaskModel b) {
  if (a.isHighPriority) {
    return -1;
  }
  if (b.isHighPriority) {
    return 1;
  } else {
    return _taskDateAddedSorter(a, b);
  }
}

int _taskDueDateSorter(TaskModel a, TaskModel b) {
  var dueDateA = a.dueDate == null ? 0 : a.dueDate.millisecondsSinceEpoch;
  var dueDateB = b.dueDate == null ? 0 : b.dueDate.millisecondsSinceEpoch;

  if (dueDateA < dueDateB) {
    return -1;
  }

  if (dueDateA > dueDateB) {
    return 1;
  }

  return _taskDateAddedSorter(a, b);
}

int _taskDateAddedSorter(TaskModel a, TaskModel b) {
  var dateAddedA = a.dateAdded == null ? 0 : a.dateAdded.millisecondsSinceEpoch;
  var dateAddedB = b.dateAdded == null ? 0 : b.dateAdded.millisecondsSinceEpoch;

  if (dateAddedA < dateAddedB) {
    return -1;
  }

  if (dateAddedA > dateAddedB) {
    return 0;
  }

  return 0;
}

int _taskAssigneeSorter(TaskModel a, TaskModel b) {
  int foldedA =
      a.assignedTo.fold(0, (prev, item) => prev.hashCode + item.hashCode);
  int foldedB =
      b.assignedTo.fold(0, (prev, item) => prev.hashCode + item.hashCode);

  return foldedA - foldedB;
}

Map<String, int> _buildTaskIndices(
    List<InflatedTaskListModel> inflatedTaskListModels) {
  var map = Map<String, int>();
  for (var taskList in inflatedTaskListModels) {
    int index = 0;
    for (var task in taskList.tasks) {
      map[task.uid] = index++;
    }
  }

  return map;
}

int _taskListSorter(TaskListModel a, TaskListModel b) {
  int dateA = a.dateAdded?.millisecondsSinceEpoch ?? 0;
  int dateB = b.dateAdded?.millisecondsSinceEpoch ?? 0;

  return dateA - dateB;
}

List<TaskListModel> _sortTaskLists(TaskListSorting sorting,
    List<TaskListModel> taskLists, List<String> listCustomSortOrder) {
  var preSortedTaskLists = taskLists.toList()..sort(_taskListSorter);

  if (sorting == TaskListSorting.custom && listCustomSortOrder != null) {
    var idMap =
        _mapTaskListsById(taskLists); // Avoids running into O^n List lookups.

    var sortedTaskLists = <TaskListModel>[];
    // Prepend Task lists that haven't been given a Custom order by the User.
    for (var taskList in preSortedTaskLists) {
      if (listCustomSortOrder.contains(taskList.uid) == false) {
        sortedTaskLists.add(taskList);
      }
    }

    // Now add remaining TaskLists honoring the Custom Sorting Order.
    for (var id in listCustomSortOrder) {
      if (idMap.containsKey(id)) {
        sortedTaskLists.add(idMap[id]);
      }
    }

    return sortedTaskLists;
  } else {
    // No Custom Sorting. Sorted by Date added. Which we already did in the pre sort.
    return preSortedTaskLists;
  }
}

Map<String, TaskListModel> _mapTaskListsById(List<TaskListModel> taskLists) {
  return Map<String, TaskListModel>.fromIterable(taskLists,
      key: (item) {
        var taskList = item as TaskListModel;
        return taskList.uid;
      },
      value: (item) => item);
}
