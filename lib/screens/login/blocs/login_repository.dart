import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pie/models/user.dart';
import 'package:pie/utils/app_string.dart';


class LoginRepository {
  final http.Client httpClient;

  LoginRepository({this.httpClient}) : assert(httpClient != null);

  Future<List<String>> login({String username, String password}) async {
    final response = await httpClient.post(
        '${AppString.baseUrl}User/login', body: jsonEncode(<String, String>{
      'username': username,
      'password': password
    }));
    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      print(user);
      return fromJsonToToken(user);
    } else {
      throw Exception('Error login');
    }
  }

  List<String> fromJsonToToken(dynamic jsonObject) {
    final List<String> list = List();
    list.add(jsonObject['token']);
    list.add(jsonObject['refresh_token']);
    return list;
  }
}