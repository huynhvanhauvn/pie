import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pie/models/user.dart';
import 'package:pie/utils/app_string.dart';


class SignupRepository {
  final http.Client httpClient;

  SignupRepository({this.httpClient}) : assert(httpClient != null);

  Future<bool> signup({String username, String password, String fullname, String gender, String birthday}) async {
    final response = await httpClient.post(
        '${AppString.baseUrl}User/signup', body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'fullname': fullname,
      'gender': gender,
      'birthday': birthday
    }));
    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      print(user);
      return true;
    } else {
      return false;
    }
  }
}