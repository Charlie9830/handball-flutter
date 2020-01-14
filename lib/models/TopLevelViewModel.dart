import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/EnableState.dart';

class TopLevelViewModel {
  final AppThemeModel data;
  final EnableStateModel enableState;
  final SplashScreenState splashScreenState;


  TopLevelViewModel({
    this.data,
    this.enableState,
    this.splashScreenState,
  });
}