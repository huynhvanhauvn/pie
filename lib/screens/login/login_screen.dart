import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pie/models/user.dart';
import 'package:pie/screens/home/home_screen.dart';
import 'package:pie/screens/login/blocs/login_bloc.dart';
import 'package:pie/screens/login/blocs/login_repository.dart';
import 'package:pie/screens/login/blocs/login_state.dart';
import 'package:pie/screens/splash/splash_screen.dart';
import 'package:pie/utils/app_string.dart';
import 'package:pie/widgets/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const TOKEN = 'token';
  static const REFRESH_TOKEN = 'refresh_token';

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final LoginRepository loginRepository =
      LoginRepository(httpClient: http.Client());

  loginFinish({String token, String refreshToken}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(LoginScreen.TOKEN, token);
    await sharedPreferences.setString(LoginScreen.REFRESH_TOKEN, refreshToken);
    print(sharedPreferences.getString(LoginScreen.TOKEN));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(loginRepository: loginRepository),
        child: Stack(
          children: [
            screen.orientation == Orientation.landscape
                ? LoginLandscape()
                : LoginPortrait(),
            BlocConsumer<LoginBloc, LoginState>(
                listener: (context, loginState) {
              if (loginState is LoginSuccess) {
                loginFinish(
                  token: loginState.token,
                  refreshToken: loginState.refreshToken,
                );
              }
            }, builder: (context, loginState) {
              if (loginState is LoginLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }
}

class LoginLandscape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: Hero(
              tag: SplashScreen.MY_LOGO,
              child: Image.asset(
                'resources/images/icon.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                LoginForm(
                  type: Type.login,
                  direction: Direction.landscape,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPortrait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 32,
                bottom: 32,
              ),
              child: Text(
                txt.login,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            LoginForm(
              type: Type.login,
            ),
          ],
        ),
      ),
    );
  }
}
