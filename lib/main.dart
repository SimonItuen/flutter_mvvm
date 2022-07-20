import 'package:advanced_course_flutter/presentation/resources/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'app/app.dart';
import 'app/di.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //to avoid sharedPrefs  returning null
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  runApp(EasyLocalization(
      child: Phoenix(child: MyApp()),
      supportedLocales: [ENGLISH_LOCAL, ARABIC_LOCAL],
      path: ASSETS_PATH_LOCALIZATION));
}
