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
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return fromJsonToListCard(series);
    } else if (response.statusCode == 401) {
      print(response.statusCode);
      final tokenResponse = await httpClient.get(
          '${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);

        final String newToken =
            sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
        final response =
            await httpClient.post('${AppString.baseUrl}Group/detail',
                headers: {HttpHeaders.authorizationHeader: newToken},
                body: jsonEncode(<String, String>{
                  'id': id,
                }));
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          return fromJsonToListCard(series);
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('List Group: ${response.statusCode}');
        } else {
          throw Exception('List Group: ${response.statusCode}');
        }
      } else {
        throw Exception('Error reset token');
      }
      throw Exception('Error list card: ${response.statusCode}');
    } else {
      print('fail');
      throw Exception('Error list group');
    }
  }

  Future<bool> removeWord({String idGroup, String idWord}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response =
        await httpClient.post('${AppString.baseUrl}Group/delete_vocab',
            body: jsonEncode(<String, String>{
              'id': idGroup,
              'idword': idWord,
            }),
            headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      final String refreshToken =
          sharedPreferences.getString(LoginScreen.REFRESH_TOKEN) ?? '';
      final tokenResponse = await httpClient.get(
          '${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);

        final String newToken =
            sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
        final response =
            await httpClient.post('${AppString.baseUrl}Group/delete_vocab',
                body: jsonEncode(<String, String>{
                  'id': idGroup,
                  'idword': idWord,
                }),
                headers: {HttpHeaders.authorizationHeader: newToken});
        if (response.statusCode == 200) {
          return true;
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Copy Group: ${response.statusCode}');
        } else {
          throw Exception('Copy Group: ${response.statusCode}');
        }
      } else {
        throw Exception('Copy reset token');
      }
    } else {
      throw Exception('Copy Group: ${response.statusCode}');
    }
  }
}
