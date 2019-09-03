import 'package:flutter/material.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/enums.dart';

class TaskListSettingsMenu extends StatelessWidget {
  TaskSorting sorting;
  final bool isDisabled;
  final bool isFaviroute;
  final onSortingChange;
  final onRename;
  final onOpenChecklistSettings;
  final onDelete;
  final onMoveToProject;
  final onChooseColor;
  final onFavouriteListChange;

  TaskListSettingsMenu({
    Key key,
    this.isDisabled,
    this.sorting,
    this.onSortingChange,
    this.onRename,
    this.onOpenChecklistSettings,
    this.onDelete,
    this.onMoveToProject,
    this.onChooseColor,
    this.onFavouriteListChange,
    this.isFaviroute,
  });

  @override
  Widget build(BuildContext context) {
    if (isDisabled == true) {
      return IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: null,
      );
    }

    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: _handleSelection,
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<dynamic>>[
            PopupMenuItem(
              child:
                  Text('Sorting', style: Theme.of(context).textTheme.subtitle),
            ),
            PopupMenuDivider(),
            CheckedPopupMenuItem(
              child: Text('Completed'),
              value: TaskSorting.completed,
              checked: sorting == TaskSorting.completed,
            ),
            CheckedPopupMenuItem(
              child: Text('Priority'),
              value: TaskSorting.priority,
              checked: sorting == TaskSorting.priority,
            ),
            CheckedPopupMenuItem(
              child: Text('Due Date'),
              value: TaskSorting.dueDate,
              checked: sorting == TaskSorting.dueDate,
            ),
            CheckedPopupMenuItem(
              child: Text('Date Added'),
              value: TaskSorting.dateAdded,
              checked: sorting == TaskSorting.dateAdded,
            ),
            CheckedPopupMenuItem(
              child: Text('Assignee'),
              value: TaskSorting.assignee,
              checked: sorting == TaskSorting.assignee,
            ),
            CheckedPopupMenuItem(
              child: Text('Alphabetically'),
              value: TaskSorting.alphabetically,
              checked: sorting == TaskSorting.alphabetically,
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              child: Text('Rename List'),
              value: 'rename list',
            ),
            PopupMenuItem(
              child: Text('Checklist Settings'),
              value: 'checklist settings',
            ),
            PopupMenuItem(
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.color_lens),
                  ),
                  Text('Choose Color')
                ]),
                value: 'choose-color'),
            PopupMenuItem(
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.favorite),
                ),
                Text('Favourite this List')
              ]),
              value: 'favourite-list',
            ),
            if (EnableStates.of(context).state.canMoveTaskList == true)
              PopupMenuItem(
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.arrow_forward),
                  ),
                  Text('Move to project')
                ]),
                value: 'move to project',
              ),
            PopupMenuDivider(),
            PopupMenuItem(
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.delete),
                ),
                Text('Delete List')
              ]),
              value: 'delete list',
            ),
          ];
        });
  }

  void _handleSelection(value) {
    switch (value) {
      case 'rename list':
        onRename();
        break;

      case 'checklist settings':
        onOpenChecklistSettings();
        break;

      case 'move to project':
        onMoveToProject();
        break;

      case 'delete list':
        onDelete();
        break;

      case 'choose-color':
        onChooseColor();
        break;

      case 'favourite-list':
        onFavouriteListChange(!isFaviroute);
        break;

      default:
        // Sorting Options
        onSortingChange(value);
        break;
    }
  }
}
