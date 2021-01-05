import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pie/models/choice.dart';
import 'package:pie/screens/signup/blocs/signup_bloc.dart';
import 'package:pie/screens/signup/blocs/signup_event.dart';
import 'package:pie/utils/app_color.dart';
import 'package:pie/utils/app_string.dart';
import 'package:pie/widgets/choices.dart';

class SignupForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  int _gender = 2;
  String _birthday = '0000-00-00';
  final List<Choice> genders = [
    Choice(title: txt.female, value: 0),
    Choice(title: txt.male, value: 1),
    Choice(title: txt.other, value: 2),
  ];
  bool _showPass = false;
  final StreamController<DateTime> _birthdayStream = StreamController();

  Future<void> _selectDate() async {
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime.now(),
    );
    setState(() {
      _birthday = DateFormat('yyyy/MM/dd').format(selectedDate ?? DateTime.now());
    });
    _birthdayStream.add(selectedDate ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: TextFormField(
                validator: (value) {
                  if (value.length <= 0) {
                    return '${txt.emptyInput} ${txt.fullname}';
                  }
                  return null;
                },
                controller: _fullnameController,
                decoration: InputDecoration(
                    hintText: txt.fullname,
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
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txt.gender,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Choices(
                    choices: genders,
                    direction: Direction.horizontal,
                    onPress: (value) {setState(() {
                      _gender = value;
                    });},
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  txt.birthday,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate();
                  },
                  child: StreamBuilder<DateTime>(
                    stream: _birthdayStream.stream,
                    initialData: DateTime.now(),
                    builder: (context, snapshot) {
                      return Text(
                        DateFormat('dd/MM/yyyy').format(snapshot.data),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    BlocProvider.of<SignupBloc>(context).add(
                      SignupRequest(
                        username: _usernameController.text,
                        password: _passwordController.text,
                        fullname: _fullnameController.text,
                        gender: _gender.toString(),
                        birthday: _birthday,
                      ),
                    );
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 48, right: 48),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      color: AppColor.primary),
                  child: Text(
                    txt.signup,
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
