import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListSettingsMenu.dart';

class TaskListHeader extends StatelessWidget {
  final String name;
  final TaskSorting sorting;
  final bool isChecklist;
  final bool isMenuDisabled;
  final Color customColor;
  final bool isFaviroute;
  final onDelete;
  final onRename;
  final onAddTaskButtonPressed;
  final onSortingChange;
  final onOpenChecklistSettings;
  final onChooseColor;
  final dynamic onMoveToProject;
  final onFavouriteListChange;

  TaskListHeader({
    Key key,
    this.name,
    this.isMenuDisabled,
    this.isChecklist,
    this.customColor,
    this.sorting,
    this.onDelete,
    this.onRename,
    this.onAddTaskButtonPressed,
    this.onSortingChange,
    this.onOpenChecklistSettings,
    this.onMoveToProject,
    this.onChooseColor,
    this.onFavouriteListChange,
    this.isFaviroute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
            color: customColor ?? Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          children: <Widget>[
            TaskListSettingsMenu(
              isDisabled: isMenuDisabled,
              onDelete: onDelete,
              onRename: onRename,
              onSortingChange: onSortingChange,
              onOpenChecklistSettings: onOpenChecklistSettings,
              sorting: sorting,
              onMoveToProject: onMoveToProject,
              onChooseColor: onChooseColor,
              onFavouriteListChange: onFavouriteListChange,
              isFaviroute: isFaviroute,
            ),

            if (isFaviroute == true) 
              Icon(Icons.favorite),
              
            if (isChecklist == true)
              IconButton(
                  icon: Icon(Icons.playlist_add_check),
                  onPressed: isMenuDisabled == true
                      ? null
                      : () => onOpenChecklistSettings()),
            Expanded(
                child: Text(name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead)),
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: onAddTaskButtonPressed,
            )
          ],
        ),
      ),
    );
  }
}
