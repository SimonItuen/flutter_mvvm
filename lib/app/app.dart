
import 'package:advanced_course_flutter/app/app_prefs.dart';
import 'package:advanced_course_flutter/app/di.dart';
import 'package:advanced_course_flutter/presentation/resources/routes_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {

  MyApp._internal(); //private named constructor

  int appState =0;
  static final MyApp instance = MyApp._internal(); //single instance

  factory MyApp() => instance; //factory for the class instance

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppPreferences _appPreferences = instance<AppPreferences>();


  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => context.setLocale(local));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
