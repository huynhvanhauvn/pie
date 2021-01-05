import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pie/models/user.dart';
import 'package:pie/screens/home/home_screen.dart';
import 'package:pie/screens/login/login_screen.dart';
import 'package:pie/screens/signup/blocs/signup_bloc.dart';
import 'package:pie/screens/signup/blocs/signup_repository.dart';
import 'package:pie/screens/signup/blocs/signup_state.dart';
import 'package:pie/screens/signup/widgets/signup.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_string.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final SignupRepository repository =
      SignupRepository(httpClient: http.Client());

  signupFinish() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocProvider(
            create: (context) => SignupBloc(repository: repository),
            child: Stack(
              children: [
                SignupPortrait(),
                BlocConsumer<SignupBloc, SignupState>(
                    listener: (context, state) {
                  if (state is SignupSuccess) {
                    signupFinish();
                  }
                }, builder: (context, loginState) {
                  if (loginState is SignupLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container();
                })
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text(''),
              leading: new IconButton(
                icon: new Icon(
                  Icons.chevron_left_rounded,
                  color: AppColor.primary,
                  size: 40,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}

class SignupPortrait extends StatelessWidget {
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
                txt.signup,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SignupForm(),
          ],
        ),
      ),
    );
  }
}
