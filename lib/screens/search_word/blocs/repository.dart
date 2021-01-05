import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:pie/models/word.dart';
import 'package:pie/utils/app_string.dart';

class ListRepository extends Equatable {
  final http.Client httpClient;

  ListRepository({this.httpClient});

  Future<List<Word>> searchWord(
      {int startIndex, int limit, String keyword}) async {
    print('/////');
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
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => throw [httpClient];
}
