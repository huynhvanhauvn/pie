import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie/screens/splash/splash_screen.dart';
import 'package:pie/utils/app_color.dart';


void main() {
  runApp(
    MyApp()
  );
}

class MyApp extends StatefulWidget {
  static const LOCAL_STORAGE_KEY = 'myLocalStorage';
  static const LANGUAGE = 'language';
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: AppColor.primary,
          textTheme: TextTheme(
              bodyText2: TextStyle(
                color: AppColor.textDark,
              ))),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: SplashScreen(),
      ),
    );
  }
}
