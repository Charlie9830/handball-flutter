import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Screens/ListSortingScreen/TaskListSortTile.dart';

class ListSortingScreen extends StatefulWidget {
  final List<TaskListModel> taskLists;

  ListSortingScreen({Key key, this.taskLists}) : super(key: key);

  _ListSortingScreenState createState() => _ListSortingScreenState();
}

class _ListSortingScreenState extends State<ListSortingScreen> {
  List<TaskListModel> sortedTaskLists;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleWillPop(context),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text('Custom List Order'),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => _handleBackButtonPressed(context))),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      'Drag and drop your lists below to place them into a custom order'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ReorderableListView(
                        onReorder: _onReorder,
                        children: _getChildren(),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<bool> _handleWillPop(BuildContext context) {
    _handleBackButtonPressed(context);
    return Future.value(false);
  }

  void _handleBackButtonPressed(BuildContext context) {
    Navigator.of(context).pop(sortedTaskLists);
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      // No Order change required
      return;
    }

    var taskLists =
        sortedTaskLists?.toList() ?? widget.taskLists.toList();
    var movedTaskList = taskLists[oldIndex];

    // Shuffle Order.
    taskLists.insert(newIndex, movedTaskList);

    if (oldIndex < newIndex) {
      taskLists.removeAt(oldIndex);
    } else {
      taskLists.removeAt(oldIndex + 1);
    }

    setState(() => sortedTaskLists = taskLists);
  }

  List<Widget> _getChildren() {
    var taskLists = sortedTaskLists ?? widget.taskLists;

    return taskLists
        .map((item) =>
            TaskListSortTile(key: Key(item.uid), title: item.taskListName))
        .toList();
  }
}
