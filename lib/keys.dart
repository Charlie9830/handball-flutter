import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final taskListAnimatedListStateKeys = Map<String, GlobalKey<AnimatedListState>>();
final homeScreenScaffoldKey = GlobalKey<ScaffoldState>();
final shareScreenScaffoldKey = GlobalKey<ScaffoldState>();
final appDrawerScaffoldKey = GlobalKey<ScaffoldState>();
final appSettingsScaffoldKey = GlobalKey<ScaffoldState>();