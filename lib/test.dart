import 'package:advanced_course_flutter/app/app.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

void updateAppState(){
  MyApp.instance.appState =10;
}

void getAppState(){
  print(MyApp.instance.appState);
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
