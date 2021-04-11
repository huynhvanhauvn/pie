import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie/models/audio.dart';
import 'package:pie/models/level.dart';
import 'package:pie/models/unit.dart';
import 'package:pie/screens/login/login_screen.dart';
import 'package:pie/utils/app_functions.dart';
import 'package:pie/utils/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListeningRepository {
  final http.Client httpClient;

  ListeningRepository({this.httpClient}) : assert(httpClient != null);

  Future<List<Level>> getListGLevel() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.get(
        '${AppString.baseUrl}Listening/levels',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return fromJsonToListLevel(series);
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
        print(newToken);
        final response = await httpClient.get(
            '${AppString.baseUrl}Listening/levels',
            headers: {HttpHeaders.authorizationHeader: newToken});
        print(response);
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
          return fromJsonToListLevel(series);
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Get List Level: ${response.statusCode}');
        } else {
          throw Exception('Get List Level: ${response.statusCode}');
        }
      } else {
        throw Exception('Error reset token');
      }
    } else {
      throw Exception('Get List Level: ${response.statusCode}');
    }
  }

  Future<List<Unit>> getListUnit({@required String id}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.post(
      '${AppString.baseUrl}Listening/units',
      body: jsonEncode(<String, String>{
        'level': id,
      }),
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return fromJsonToListUnit(series);
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
        final response = await httpClient.post(
          '${AppString.baseUrl}Listening/units',
          body: jsonEncode(<String, String>{
            'level': id,
          }),
          headers: {HttpHeaders.authorizationHeader: newToken},
        );
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
          return fromJsonToListUnit(series);
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Get List Unit: ${response.statusCode}');
        } else {
          throw Exception('Get List Unit: ${response.statusCode}');
        }
      } else {
        throw Exception('Error reset token');
      }
    } else {
      throw Exception('Get List Unit: ${response.statusCode}');
    }
  }

  Future<List<Audio>> getListAudio({@required String idUnit, @required String idLevel}) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.post(
      '${AppString.baseUrl}Listening/audios',
      body: jsonEncode(<String, String>{
        'id_unit': idUnit,
        // 'level': idLevel
      }),
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return fromJsonToListAudio(series);
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
        final response = await httpClient.post(
          '${AppString.baseUrl}Listening/audios',
          body: jsonEncode(<String, String>{
            'id_unit': idUnit,
            // 'level': idLevel
          }),
          headers: {HttpHeaders.authorizationHeader: newToken},
        );
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
          return fromJsonToListAudio(series);
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Get List Audio: ${response.statusCode}');
        } else {
          throw Exception('Get List Audio: ${response.statusCode}');
        }
      } else {
        throw Exception('Error reset token');
      }
    } else {
      throw Exception('Get List Audio: ${response.statusCode}');
    }
  }

  Future<Audio> getAudio({@required String id}) async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.post(
      '${AppString.baseUrl}Listening/audio_detail',
      body: jsonEncode(<String, String>{
        'id': id,
      }),
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (response.statusCode == 200) {
      final series = jsonDecode(response.body);
      return fromJsonToAudio(series);
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
        final response = await httpClient.post(
          '${AppString.baseUrl}Listening/audio_detail',
          body: jsonEncode(<String, String>{
            'id': id,
          }),
          headers: {HttpHeaders.authorizationHeader: newToken},
        );
        if (response.statusCode == 200) {
          final series = jsonDecode(response.body);
          print(fromJsonToListSeries(series));
          return fromJsonToAudio(series);
        } else if (response.statusCode == 401) {
          // logout
          throw Exception('Get Audio: ${response.statusCode}');
        } else {
          throw Exception('Get Audio: ${response.statusCode}');
        }
      } else {
        throw Exception('Error reset token');
      }
    } else {
      throw Exception('Get Audio: ${response.statusCode}');
    }
  }
}
