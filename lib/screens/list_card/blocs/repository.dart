import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/screens/login/login_screen.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:pie/utils/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListCardRepository {
  final http.Client httpClient;

  ListCardRepository({this.httpClient}) : assert(httpClient != null);

  Future<FlashCardSeries> getListCard({id: String}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final String refreshToken =
        sharedPreferences.getString(LoginScreen.REFRESH_TOKEN) ?? '';
    final response = await httpClient.post('${AppString.baseUrl}Group/detail',
        headers: {HttpHeaders.authorizationHeader: token},
        body: jsonEncode(<String, String>{
          'id': id,
        }));
    print('go');
    if (response.statusCode == 200) {
      print('re suc');
      print(response.body);
      final series = jsonDecode(response.body);
      // print(series);
      return fromJsonToListCard(series);
    } else if (response.statusCode == 401) {
      print(response.statusCode);
      final tokenResponse = await httpClient.get(
          '${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        print(tokenResponse.statusCode);
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);
        getListCard();
      } else {
        throw Exception('Error reset token');
      }
      throw Exception('Error list card: ${response.statusCode}');
    } else {
      print('fail');
      throw Exception('Error list group');
    }
  }
}
