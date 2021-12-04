import 'dart:convert';

import 'package:news_app/Model/Apis/api_urls.dart';
import 'package:news_app/Model/Repository/news_repository.dart';
import 'package:http/http.dart' as http;

class TopHeadLineNewsApi extends TopHeadLineNewsRepository {
  @override
  Future<List> getTopHeadLineNews(
      {required String? country, required String category}) async {
    List _topHeadLine;
    final String url =
        '${NewsApiUrlGenerator.baseUrl}top-headlines?country=$country&category=$category&apiKey=${NewsApiUrlGenerator.apiKey}';
    try {
      final http.Response _response = await http.get(Uri.parse(url));
      print('from Api: $_response');
      print(_response.statusCode);
      if (_response.statusCode != 200) return [];
      var _responseBody = jsonDecode(_response.body);
      _topHeadLine = _responseBody["articles"];
    } catch (e) {
      _topHeadLine = [];
    }
    print('from Api: $_topHeadLine');
    return _topHeadLine;
  }
}
