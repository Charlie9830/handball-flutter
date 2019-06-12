import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ProjectModel.dart';

class ShareProjectViewModel {
  final ProjectModel projectEntity;
  final ShareProjectScreenType type;
  final dynamic onInvite;

  ShareProjectViewModel({
    this.projectEntity,
    this.type,
    this.onInvite,
  });
}