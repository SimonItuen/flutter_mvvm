import 'package:advanced_course_flutter/app/di.dart';
import 'package:advanced_course_flutter/presentation/forgot_password/forgot_password.dart';
import 'package:advanced_course_flutter/presentation/login/login.dart';
import 'package:advanced_course_flutter/presentation/main/main_view.dart';
import 'package:advanced_course_flutter/presentation/onboarding/onboarding.dart';
import 'package:advanced_course_flutter/presentation/register/register.dart';
import 'package:advanced_course_flutter/presentation/splash/splash.dart';
import 'package:advanced_course_flutter/presentation/store_details/store_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'strings_manager.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onboarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => SplashView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => OnBoardingView());
      case Routes.forgotPasswordRoute:
        initForgotPasswordModule();
        return MaterialPageRoute(builder: (_) => ForgotPasswordView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => RegisterView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => MainView());
      case Routes.storeDetailsRoute:
        initStoreDetailsModule();
        return MaterialPageRoute(builder: (_) => StoreDetailsView());
      default:
        return UnDefinedRoute();
    }
  }

  static Route<dynamic> UnDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound).tr(),
              ),
              body: Center(child: Text(AppStrings.noRouteFound).tr()),
            ));
  }
}
