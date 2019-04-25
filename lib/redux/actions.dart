import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SelectProject {
  final String uid;

  SelectProject(this.uid);
}

class SetUser {
  final User user;

  SetUser({this.user});
}

class ReceiveLocalProjects {
  final List<ProjectModel> projects;

  ReceiveLocalProjects({this.projects});
}

class ReceiveLocalTasks {
  final List<TaskModel> tasks;

  ReceiveLocalTasks({this.tasks});
}

class ReceiveLocalTaskLists {
  final List<TaskListModel> taskLists;

  ReceiveLocalTaskLists({this.taskLists});
}

class NavigateToProject {

}

class NavigateToAppDrawer {
  
}

// Thunks
ThunkAction<AppState> updateTaskComplete(String taskId, bool newValue) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;

    await Firestore.instance.collection('users').document(userId).collection('tasks').document(taskId).updateData({'isComplete': newValue});
  };
}

ThunkAction<AppState> subscribeToLocalTaskLists(String userId) {
  return (Store<AppState> store) async {
    Firestore.instance.collection('users').document(userId).collection('taskLists').snapshots().listen( (data) {
      var taskLists = <TaskListModel>[];
      data.documents.forEach( (doc) {
        taskLists.add(
          TaskListModel(
            uid: doc['uid'],
            project: doc['project'],
            taskListName: doc['taskListName'],
          )
        );
      });

      store.dispatch( ReceiveLocalTaskLists(taskLists: taskLists));
    });
  };
}

ThunkAction<AppState> subscribeToLocalTasks(String userId) {
  return (Store<AppState> store) async {
    Firestore.instance.collection('users').document(userId).collection('tasks').snapshots().listen( (data) {
      var tasks = <TaskModel>[];
      data.documents.forEach( (doc) {
        tasks.add(
          TaskModel(
            uid: doc['uid'],
            project: doc['project'],
            taskList: doc['taskList'],
            taskName: doc['taskName'],
            dueDate: doc['dueDate'],
            isComplete: doc['isComplete'],
            ),
        );
      });

      store.dispatch(ReceiveLocalTasks(tasks: tasks));
    });
  };
}

ThunkAction<AppState> subscribeToLocalProjects(String userId) {
  return (Store<AppState> store) async {
    Firestore.instance.collection('users').document(userId).collection('projects').snapshots().listen((data) {
      var projects = <ProjectModel>[];
      data.documents.forEach( (doc) {
        projects.add(ProjectModel(uid: doc['projectId'], name: doc['projectName']));
      });

      store.dispatch(ReceiveLocalProjects(projects: projects));
    });
  };
}

ThunkAction<AppState> signInUser() {
  return (Store<AppState> store) async {
    print('Signing in User');
    final FirebaseUser user = await auth.signInWithEmailAndPassword(
        email: 'a@test.com', password: 'adingusshrew');

    print('Logged in');

    store.dispatch(SetUser(
        user: new User(
            isLoggedIn: true,
            displayName: user.displayName,
            userId: user.uid,
            email: user.email)
            ));

    store.dispatch(subscribeToLocalProjects(user.uid));
    store.dispatch(subscribeToLocalTasks(user.uid));
    store.dispatch(subscribeToLocalTaskLists(user.uid));

  };
}
