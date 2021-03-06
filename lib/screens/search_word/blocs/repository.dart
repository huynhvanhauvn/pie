import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:pie/models/word.dart';
import 'package:pie/screens/login/login_screen.dart';
import 'package:pie/utils/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListRepository extends Equatable {
  final http.Client httpClient;

  ListRepository({this.httpClient});

  Future<List<Word>> searchWord(
      {int startIndex, int limit, String keyword}) async {
    print(startIndex);
    print(limit);
    print(keyword);
    final response = await httpClient.post('${AppString.baseUrl}Vocab/list',
        body: jsonEncode(<String, String>{
          'index': startIndex.toString(),
          'size': limit.toString(),
          'key': keyword,
        }));
    if (response.statusCode == 200) {
      final obj = jsonDecode(response.body);
      final data = obj['list'] as List;
      return data.map((rawData) {
        return Word(
          id: rawData['id'],
          word: rawData['word'],
          meaning: rawData['meaning'],
          type: rawData['type'],
          picture: rawData['picture'],
          selected: false,
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }

  Future<bool> addWords({
    String idSeries,
    List<Word> words,
  }) async {
    print(jsonEncode(<String, String>{
      'id': idSeries,
      'vocabs': jsonEncode(words.map((e) => e.toIdJson()).toList()),
    }));
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final String refreshToken =
        sharedPreferences.getString(LoginScreen.REFRESH_TOKEN) ?? '';
    final response = await httpClient.post(
      '${AppString.baseUrl}Group/add_to_group',
      body: jsonEncode(<String, String>{
        'id': idSeries,
        'vocabs': jsonEncode(words.map((e) => e.toIdJson()).toList()),
      }),
      headers: {HttpHeaders.authorizationHeader: token},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {

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
          '${AppString.baseUrl}Group/add_to_group',
          body: jsonEncode(<String, String>{
            'id': idSeries,
            'vocabs': jsonEncode(words.map((e) => e.toIdJson()).toList()),
          }),
          headers: {HttpHeaders.authorizationHeader: newToken},
        );
        if (response.statusCode == 200) {
          return true;
        } else if (response.statusCode == 400) {
          return false;
        } else {
          throw Exception('Add word failed ${response.statusCode}');
        }
      } else {
        throw Exception('Add word failed ${tokenResponse.statusCode}');
      }

    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Add word failed');
    }
  }

  Future<bool> addGroup({
    String groupName,
    List<Word> words,
  }) async {
    print(jsonEncode(<String, String>{
      'group_name': groupName,
      'vocabs': jsonEncode(words.map((e) => e.toIdJson()).toList()),
    }));

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final String refreshToken = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
    final response = await httpClient.post(
      '${AppString.baseUrl}Group/vocabs',
      body: jsonEncode(<String, String>{
        'group_name': groupName,
        'vocabs': jsonEncode(words.map((e) => e.toIdJson()).toList()),
      }),
      headers: {HttpHeaders.authorizationHeader: token},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {

      final tokenResponse = await httpClient.get(
          '${AppString.baseUrl}User/reset',
          headers: {HttpHeaders.authorizationHeader: refreshToken});
      print(tokenResponse.statusCode);
      if (tokenResponse.statusCode == 200) {
        final user = jsonDecode(tokenResponse.body);
        await sharedPreferences.setString(LoginScreen.TOKEN, user['new_token']);

        final String newToken = sharedPreferences.getString(LoginScreen.TOKEN) ?? '';
        final response = await httpClient.post(
          '${AppString.baseUrl}Group/vocabs',
          body: jsonEncode(<String, String>{
            'group_name': groupName,
            'vocabs': jsonEncode(words.map((e) => e.toIdJson()).toList()),
          }),
          headers: {HttpHeaders.authorizationHeader: newToken},
        );
        if (response.statusCode == 200) {
          return true;
        } else if (response.statusCode == 400) {
          return false;
        } else {
          throw Exception('Add group failed ${response.statusCode}');
        }

      } else {
        throw Exception('Add group failed ${tokenResponse.statusCode}');
      }

    } else if (response.statusCode == 400) {
      return false;
    } else {
      throw Exception('Add group failed');
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => throw [httpClient];
}
