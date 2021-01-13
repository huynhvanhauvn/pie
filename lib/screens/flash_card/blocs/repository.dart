import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/screens/login/login_screen.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:pie/utils/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashCardRepository {
  final http.Client httpClient;

  FlashCardRepository({this.httpClient}) : assert(httpClient != null);
  bool a = true;
  Future<List<FlashCardSeries>> getListGroup() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    print('Token: ${token}');
    final response = await httpClient.get('${AppString.baseUrl}Group/list',
        headers: {HttpHeaders.authorizationHeader: a ? 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MTA0NTk5NDUsIm5iZiI6MTYxMDQ1OTk0NSwiZXhwIjoxNjEwNDYzNTQ1LCJkYXRhIjp7ImlkIjoiMzQiLCJ1c2VybmFtZSI6InRpZW4ifX0.t5n_Q0lHJ-_8v5Bg6EQR151qHzZBrlKgDrzvWhBxke4' : token});
    print('go');
    a = false;
    if (response.statusCode == 200) {
      print('re suc');
      print(response.body);
      final series = jsonDecode(response.body);
      print(fromJsonToListSeries(series));
      return fromJsonToListSeries(series);
    } else if (response.statusCode == 401) {
      print(response.statusCode);
      refreshToken();
      throw Exception('Get List Group: ${response.statusCode}');
    } else {
      throw Exception('Get List Group: ${response.statusCode}');
    }
  }

  Future<void> refreshToken() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String refreshToken = sharedPreferences.getString(
        LoginScreen.REFRESH_TOKEN) ?? '';
    final tokenResponse = await httpClient.get('${AppString.baseUrl}User/reset',
        headers: {HttpHeaders.authorizationHeader: refreshToken});
    print(tokenResponse.statusCode);
    if (tokenResponse.statusCode == 200) {
      final user = jsonDecode(tokenResponse.body);
      await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);
      print(sharedPreferences.getString(LoginScreen.TOKEN) ?? '');
      getListGroup();
    } else {
      throw Exception('Error reset token');
    }
  }
}
