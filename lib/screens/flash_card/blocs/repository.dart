import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pie/main.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/models/user.dart';
import 'package:pie/screens/login/login_screen.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:pie/utils/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashCardRepository {
  final http.Client httpClient;

  FlashCardRepository({this.httpClient}) : assert(httpClient != null);

  Future<List<FlashCardSeries>> getListGroup() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final String refreshToken = sharedPreferences.getString(LoginScreen.REFRESH_TOKEN) ?? '';
    final response = await httpClient.get('${AppString.baseUrl}Group/list',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return fromJsonToListSeries(series);
    } else if (response.statusCode == 401) {
      print(response.statusCode);
      final tokenResponse = await httpClient.get('${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if(tokenResponse.statusCode == 200) {
        print(tokenResponse.statusCode);
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);
        getListGroup();
      } else {
        throw Exception('Error reset token');
      }
    } else {
      throw Exception('Error list group');
    }
  }
}
