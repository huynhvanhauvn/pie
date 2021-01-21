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

  Future<List<FlashCardSeries>> getListGroup() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.get('${AppString.baseUrl}Group/list',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return fromJsonToListSeries(series);
    } else if (response.statusCode == 401) {

      final String refreshToken = sharedPreferences.getString(
          LoginScreen.REFRESH_TOKEN) ?? '';
      final tokenResponse = await httpClient.get('${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);

        final String newToken = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
        final response = await httpClient.get('${AppString.baseUrl}Group/list',
            headers: {HttpHeaders.authorizationHeader: newToken});
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
          return fromJsonToListSeries(series);
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Get List Group: ${response.statusCode}');
        } else {
          throw Exception('Get List Group: ${response.statusCode}');
        }
      } else {
        throw Exception('Error reset token');
      }
    } else {
      throw Exception('Get List Group: ${response.statusCode}');
    }
  }

  Future<bool> renameSeries({String id, String name}) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.post('${AppString.baseUrl}Group/update',
        body: jsonEncode(<String, String>{
          'id': id,
          'group_name': name,
        }),
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return true;
    } else if (response.statusCode == 401) {

      final String refreshToken = sharedPreferences.getString(
          LoginScreen.REFRESH_TOKEN) ?? '';
      final tokenResponse = await httpClient.get('${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);

        final String newToken = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
        final response = await httpClient.post('${AppString.baseUrl}Group/update',
            body: jsonEncode(<String, String>{
              'id': id,
              'group_name': name,
            }),
            headers: {HttpHeaders.authorizationHeader: newToken});
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
          return true;
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Rename Group: ${response.statusCode}');
        } else {
          throw Exception('Rename Group: ${response.statusCode}');
        }
      } else {
        throw Exception('Error reset token');
      }
    } else {
      throw Exception('Rename Group: ${response.statusCode}');
    }
  }

  Future<bool> deleteSeries({String id}) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.post('${AppString.baseUrl}Group/delete',
        body: jsonEncode(<String, String>{
          'id': id,
        }),
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return true;
    } else if (response.statusCode == 401) {

      final String refreshToken = sharedPreferences.getString(
          LoginScreen.REFRESH_TOKEN) ?? '';
      final tokenResponse = await httpClient.get('${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);

        final String newToken = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
        final response = await httpClient.post('${AppString.baseUrl}Group/delete',
            body: jsonEncode(<String, String>{
              'id': id,
            }),
            headers: {HttpHeaders.authorizationHeader: newToken});
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
          return true;
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Delete Group: ${response.statusCode}');
        } else {
          throw Exception('Delete Group: ${response.statusCode}');
        }
      } else {
        throw Exception('Delete reset token');
      }
    } else {
      throw Exception('Delete Group: ${response.statusCode}');
    }
  }

  Future<bool> copySeries({String id}) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.post('${AppString.baseUrl}Group/share',
        body: jsonEncode(<String, String>{
          'idgroup': id,
        }),
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return true;
    } else if (response.statusCode == 401) {

      final String refreshToken = sharedPreferences.getString(
          LoginScreen.REFRESH_TOKEN) ?? '';
      final tokenResponse = await httpClient.get('${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);

        final String newToken = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
        final response = await httpClient.post('${AppString.baseUrl}Group/share',
            body: jsonEncode(<String, String>{
              'idgroup': id,
            }),
            headers: {HttpHeaders.authorizationHeader: newToken});
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
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
