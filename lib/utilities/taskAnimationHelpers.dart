import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/configValues.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/GroupedDocumentChanges.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/presentation/ListEntryExitAnimation.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/utilities/TaskAnimationUpdate.dart';

void driveTaskAdditionAnimations(
    List<TaskAnimationUpdate> taskAnimationUpdates) {
  /*
          WHAT THE F**K?
          AnimatedLists and their component removeItem() and insertItem() methods are designed to really only deal with single
          mutations at a time. When you try and make multiple mutations in one pass, you have to make sure that the index is
          updated for each following item, otherwise the AnimatedList will try to start removing items at incorrect indexes,
          throwing an out of range index exception. The easiest way to do this is to Build the doc changes into a List of
          TaskAnimationUpdate objects, then sort them by TaskList, then index in descending order. That way, we don't have to
          adjust any following indexes as we are mutating the AnimatedList.
        */

  for (var update in taskAnimationUpdates) {
    var index = update.index;
    var listStateKey = update.listStateKey;

    if (index != null && listStateKey?.currentState != null) {
      // If the index is null, that means that the parent TaskList isn't on Device yet, Don't PANIC! We can just ignore
      // the Animation Update of that Task because once the TaskList arrives, it will be rendered in the initialRender of
      // list anyway.
      listStateKey.currentState.insertItem(index, duration: taskEntryExitAnimationDuration);
    }
  }
}

void driveTaskRemovalAnimations(
    List<TaskAnimationUpdate> taskRemovalAnimationUpdates, Map<String, MemberModel> memberLookup) {
  /*
          WHAT THE F**K?
          AnimatedLists and their component removeItem() and insertItem() methods are designed to really only deal with single
          mutations at a time. When you try and make multiple mutations in one pass, you have to make sure that the index is
          updated for each following item, otherwise the AnimatedList will try to start removing items at incorrect indexes,
          throwing an out of range index exception. The easiest way to do this is to Build the doc changes into a List of
          TaskAnimationUpdate objects, then sort them by TaskList, then index in descending order. That way, we don't have to
          adjust any following indexes as we are mutating the AnimatedList.

          TODO: Could we improve the performance of this by instead of Sorting Tasks then TaskLists, as we remove each Task, check if the last task removed was before or after
          the current one, and have an offsetInteger that gets a +1, -1 or 0 update depending on that conditional?
        */

  for (var update in taskRemovalAnimationUpdates) {
    var index = update.index;
    var listStateKey = update.listStateKey;
    var task = update.task;

    if (index != null && listStateKey?.currentState != null) {
      listStateKey.currentState.removeItem(index, (context, animation) {
        return ListEntryExitAnimation(
          key: Key(task.uid),
          animation: animation,
          child: Task(
            key: Key(task.uid),
            model: TaskViewModel(data: task, assignments: task.getAssignments(memberLookup)),
          ),
        );
      }, duration: taskEntryExitAnimationDuration );
    }
  }
}

int getTaskAnimationIndex(Map<String, int> indices, String taskId) {
  return indices[taskId];
}

GlobalKey<AnimatedListState> getAnimatedListStateKey(String taskListId) {
  return taskListAnimatedListStateKeys[taskListId];
}

GroupedTaskDocumentChanges getGroupedTaskDocumentChanges(
    List<DocumentChange> firestoreDocChanges,
    InflatedProjectModel currentInflatedProject,
    Map<String, TaskModel> flaggedAsDeletedTasks,
    Map<String, TaskModel> existingTasksById) {
  var groupedChanges = GroupedTaskDocumentChanges();

  for (var change in firestoreDocChanges) {
    if (change.type == DocumentChangeType.removed) {
      groupedChanges.removed.add(CustomDocumentChange(
        uid: change.document.documentID,
        taskList: change.document.data['taskList'],
        document: change.document,
      ));
    }

    if (change.type == DocumentChangeType.modified) {
      groupedChanges.modified.add(CustomDocumentChange(
        uid: change.document.documentID,
        taskList: change.document.data['taskList'],
        document: change.document,
      ));

      if (currentInflatedProject != null &&
          currentInflatedProject.data.uid == change.document.data['project']) {
        // We may need to adjust what is in the added, modifed and removed collections to appease the Task AnimatedList.
        if (_didMoveTaskList(change.document, existingTasksById)) {
          // A Task has moved. Whilst the project is selected. The Animation system won't catch it if we leave it
          // simply as a modified Task. Therefore, we need to add the old version of the Task to the removed collection then
          // add the new version (with the updated taskList field) to the added collection.
          var oldTask = existingTasksById[change.document.documentID];

          if (oldTask != null) {
            groupedChanges.removed.add(CustomDocumentChange(
              uid: change.document.documentID,
              taskList: oldTask.taskList,
              document: change.document,
            ));

            groupedChanges.added.add(CustomDocumentChange(
              uid: change.document.documentID,
              taskList: change.document.data['taskList'],
              document: change.document,
            ));
          }
        }

        // Task has been flagged as Deleted.
        if (flaggedAsDeletedTasks.containsKey(change.document.documentID)) {
          groupedChanges.removed.add(CustomDocumentChange(
            uid: change.document.documentID,
            taskList: change.document.data['taskList'],
            document: change.document,
          ));
        }

        // Task has been un-flagged as Deleted.
        // We infer this by checking if the task exists in the State. Because we don't add tasks that have been flagged as deleted to State. We can safely assume
        // that the task has been un-deleted on account of the fact that we are in the Firestore Modified doc changes.. ie Firestore thinks we already have this task
        // in State.
        // *********
        // IF THIS FAILS IN FUTURE
        // *********
        // Don't panic. Just Save the deleted tasks into the State, but put them in a seperate map. That way, here can compare against that map to determine if the task has
        // been un-deleted.
        if (existingTasksById.containsKey(change.document.documentID) ==
            false) {
          groupedChanges.added.add(CustomDocumentChange(
            uid: change.document.documentID,
            taskList: change.document.data['taskList'],
            document: change.document,
          ));
        }
      }
    }

    if (change.type == DocumentChangeType.added) {
      groupedChanges.added.add(CustomDocumentChange(
        uid: change.document.documentID,
        taskList: change.document.data['taskList'],
        document: change.document,
      ));
    }
  }

  return groupedChanges;
}

bool _didMoveTaskList(
    DocumentSnapshot incomingDoc, Map<String, TaskModel> existingTasksById) {
  var taskId = incomingDoc.documentID;
  var existingTask = existingTasksById[taskId];

  if (existingTask == null) {
    return false;
  }

  return existingTask.taskList != incomingDoc.data['taskList'];
}

List<TaskAnimationUpdate> getTaskRemovalAnimationUpdates(
    List<CustomDocumentChange> removedCustomDocumentChanges,
    Map<String, int> preMutationTaskIndices,
    String userId) {
  var list = removedCustomDocumentChanges.map((change) {
    return TaskAnimationUpdate(
      task: TaskModel.fromDoc(change.document, userId),
      index: getTaskAnimationIndex(preMutationTaskIndices, change.uid),
      listStateKey: getAnimatedListStateKey(change.taskList),
    );
  }).toList();

  list.sort(TaskAnimationUpdate.removalSorter);
  return list;
}

List<TaskAnimationUpdate> getTaskAdditionAnimationUpdates(
    List<CustomDocumentChange> addedCustomDocumentChanges,
    Map<String, int> postMutationTaskIndices) {
  var list = addedCustomDocumentChanges.map((docChange) {
    return TaskAnimationUpdate(
      index: getTaskAnimationIndex(
          postMutationTaskIndices, docChange.document.documentID),
      listStateKey:
          getAnimatedListStateKey(docChange.document.data['taskList']),
      task: null, // Additions don't require the actual Task.
    );
  }).toList();

  list.sort(TaskAnimationUpdate.additionSorter);
  return list;
}
