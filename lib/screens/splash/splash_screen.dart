import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pie/main.dart';
import 'package:pie/screens/home/home_screen.dart';
import 'package:pie/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const MY_LOGO = 'my_logo';
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  handleGo() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(MyApp.LANGUAGE, Localizations.localeOf(context).languageCode);
    final String idUser = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    Timer(Duration(seconds: 1), () {
      print(idUser);
      if(idUser.isNotEmpty) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 800),
                pageBuilder: (_, __, ___) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 800),
                pageBuilder: (_, __, ___) => LoginScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    handleGo();
    return Scaffold(
      body: Center(
        child: Text('Pie'),
        // child: Hero(
        //   tag: SplashScreen.MY_LOGO,
        //   child: Image.asset(
        //     'resources/images/icon.png',
        //     width: 100,
        //     height: 100,
        //   ),
        // ),
      ),
    );
  }
}
