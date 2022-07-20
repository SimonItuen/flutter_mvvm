import 'dart:async';

import 'package:advanced_course_flutter/app/app_prefs.dart';
import 'package:advanced_course_flutter/app/di.dart';
import 'package:advanced_course_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/color_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(Duration(seconds: 2), _goNext);
  }

  _goNext() {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) =>{
      if (isUserLoggedIn) {
        //navigate to main screen
        Navigator.pushReplacementNamed(context, Routes.mainRoute)
      } else {
        _appPreferences.isOnBoardingScreenViewed().then((isOnBoardingScreenViewed)=> {
          if (isOnBoardingScreenViewed) {
            Navigator.pushReplacementNamed(context, Routes.loginRoute)
          } else {
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoute)
          }
        })
      }
    });

    Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.primary,
        body: Center(
            child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        )));
  }
}
