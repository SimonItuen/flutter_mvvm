import 'package:advanced_course_flutter/app/app_prefs.dart';
import 'package:advanced_course_flutter/data/data_source/local_data_source.dart';
import 'package:advanced_course_flutter/presentation/resources/assets_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/language_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/routes_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/strings_manager.dart';
import 'package:advanced_course_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/di.dart';
import 'dart:math' as math;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppPreferences _appPreferences = instance<AppPreferences>();
  LocalDataSource _localDataSource = instance<LocalDataSource>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppPadding.p8),
      children: [
        ListTile(
          title: Text(AppStrings.changeLanguage, style: Theme.of(context).textTheme.headline4).tr(),
          leading: SvgPicture.asset(ImageAssets.changeLangIc),
          trailing: Transform(
            transform: Matrix4.rotationY(_isRTL()? math.pi: 0),
            alignment: Alignment.center,
              
              child: SvgPicture.asset(ImageAssets.settingsRightArrowIc)),
          onTap: (){
            _changeLanguage();
          },
        ),
        ListTile(
          title: Text(AppStrings.contactUs, style: Theme.of(context).textTheme.headline4).tr(),
          leading: SvgPicture.asset(ImageAssets.contactUsIc),
          trailing: Transform(
              transform: Matrix4.rotationY(_isRTL()? math.pi: 0),
              alignment: Alignment.center,

              child: SvgPicture.asset(ImageAssets.settingsRightArrowIc)),
          onTap: (){
            _contactUs();
          },
        ),
        ListTile(
          title: Text(AppStrings.inviteYourFriends, style: Theme.of(context).textTheme.headline4).tr(),
          leading: SvgPicture.asset(ImageAssets.inviteFriendsIc),
          trailing: Transform(
              transform: Matrix4.rotationY(_isRTL()? math.pi: 0),
              alignment: Alignment.center,

              child: SvgPicture.asset(ImageAssets.settingsRightArrowIc)),
          onTap: (){
            _inviteFriends();
          },
        ),
        ListTile(
          title: Text(AppStrings.logout, style: Theme.of(context).textTheme.headline4,).tr(),
          leading: SvgPicture.asset(ImageAssets.logoutIc),
          trailing: Transform(
              transform: Matrix4.rotationY(_isRTL()? math.pi: 0),
              alignment: Alignment.center,

              child: SvgPicture.asset(ImageAssets.settingsRightArrowIc)),
          onTap: (){
            _logout();
          },
        ),
      ],
    );
  }
  bool _isRTL(){
    return context.locale == ARABIC_LOCAL; //app is in arabic language
  }
  void _changeLanguage(){
    //I will apply localisation later
    _appPreferences.setLanguageChanged();
    Phoenix.rebirth(context); //restart to apply languages

  }

  void _contactUs(){
    //its a task for you to open any web page with dummy content
  }

  void _inviteFriends(){
  //its a task to share app name with friends

  }

  void _logout(){
    _appPreferences.logout(); //clear loin flag from app prefs
    _localDataSource.clearCache();
    Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
  }

}
