import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/utilities/activivtyFeedUpdaters.dart';
import 'package:handball_flutter/utilities/firestoreReferenceGetters.dart';
import 'package:handball_flutter/utilities/normalizeDate.dart';
import 'package:redux/redux.dart';

void renewChecklist(TaskListModel checklist, String projectName, Store<AppState> store,
    {bool isManuallyInitiated = false}) async {
  if (checklist.settings.checklistSettings.isDueForRenew == false &&
      isManuallyInitiated == false) {
    return;
  }

  // 'unComplete' related Tasks.
  var batch = Firestore.instance.batch();
  var snapshot = await getTasksCollectionRef(checklist.project)
      .where('taskList', isEqualTo: checklist.uid)
      .getDocuments();

  snapshot.documents
      .forEach((doc) => batch.updateData(doc.reference, {'isComplete': false}));

  // Activity Feed.
  if (isManuallyInitiated == true) {
    updateActivityFeedToBatch(
      batch: batch,
      projectId: checklist.project,
      projectName: projectName,
      user: store.state.user,
      type: ActivityFeedEventType.renewChecklist,
      title: 'manually renewed the checklist ${checklist.taskListName}',
      details: '',
    );
  }

  try {
    batch.commit();
  } catch (error) {
    throw error;
  }

  // Update TaskList.
  if (isManuallyInitiated == false) {
    var currentChecklistSettings = checklist.settings.checklistSettings;
    var newSettings = checklist.settings.copyWith(
        checklistSettings: currentChecklistSettings.copyWith(
            lastRenewDate: determineNextRenewDate(
                currentChecklistSettings.lastRenewDate ??
                    currentChecklistSettings.initialStartDate,
                currentChecklistSettings.renewInterval)));

    var ref =
        getTaskListsCollectionRef(checklist.project).document(checklist.uid);

    try {
      ref.updateData({'settings': newSettings.toMap()});
    } catch (error) {
      throw error;
    }
  }
}

DateTime determineNextRenewDate(DateTime lastRenewDate, int renewInterval) {
  assert(lastRenewDate != null);

  var now = normalizeDate(DateTime.now());
  var projectedRenewDate = lastRenewDate.add(Duration(days: renewInterval));
  if (projectedRenewDate.isAfter(now)) {
    return projectedRenewDate;
  }

  // The next projectedRenewDate is still behind Today's Date. We have to play catchup. In other words, wind the date forward
  // honoring the renewInterval until we find a date in the Future.
  while (now.isAfter(projectedRenewDate)) {
    projectedRenewDate = projectedRenewDate.add(Duration(days: renewInterval));
  }

  return projectedRenewDate;
}