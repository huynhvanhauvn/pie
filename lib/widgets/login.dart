import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/screens/login/blocs/Login_event.dart';
import 'package:pie/screens/login/blocs/login_bloc.dart';
import 'package:pie/screens/signup/signup_screen.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_string.dart';

enum Type { login, signup }
enum Direction { portrait, landscape }

class LoginForm extends StatefulWidget {
  final Type type;
  final Direction direction;

  LoginForm({@required this.type, @required this.direction});

  @override
  State<StatefulWidget> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPass = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: widget.direction == Direction.landscape
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value.length <= 0) {
                    return '${txt.emptyInput} ${txt.username}';
                  }
                  return null;
                },
                controller: _usernameController,
                decoration: InputDecoration(
                    hintText: txt.username,
                    hintStyle: TextStyle(color: AppColor.text),
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none),
                    fillColor: AppColor.grey.withOpacity(0.28),
                    filled: true),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value.length > 16) {
                    return '${txt.password} ${txt.overInput} 6 ${txt.character}';
                  }
                  if (value.length <= 0) {
                    return '${txt.emptyInput} ${txt.password}';
                  }
                  return null;
                },
                controller: _passwordController,
                obscureText: !_showPass,
                decoration: InputDecoration(
                  hintText: txt.password,
                  hintStyle: TextStyle(color: AppColor.text),
                  contentPadding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide.none),
                  fillColor: AppColor.grey.withOpacity(0.28),
                  filled: true,
                  suffixIcon: IconButton(
                      icon: Icon(_showPass
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye_rounded),
                      onPressed: () {
                        setState(() {
                          _showPass = !_showPass;
                        });
                      }),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: widget.direction == Direction.landscape
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.center,
              children: [
                Text('${txt.orCreate} '),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    txt.register,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    BlocProvider.of<LoginBloc>(context).add(LoginRequest(
                        username: _usernameController.text,
                        password: _passwordController.text));
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 48, right: 48),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      color: AppColor.primary),
                  child: Text(
                    txt.login,
                    style: TextStyle(
                        color: AppColor.textDark, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
