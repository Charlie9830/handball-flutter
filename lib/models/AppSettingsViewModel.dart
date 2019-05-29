import 'package:handball_flutter/enums.dart';

class AppSettingsViewModel {
  final AppSettingsTabs initialTab;
  final dynamic onClose;

  AppSettingsViewModel({
    this.initialTab,
    this.onClose,
  });
}