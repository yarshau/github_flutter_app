import 'dart:convert';

import 'package:github_flutter_app/github_model.dart';
import 'package:http/http.dart' as http;

class GitHubClient {
  GitHubModel _gitHubModel = GitHubModel();

  Future<List<List<dynamic>>> getItems(String query) async {
    final List<List<dynamic>> _result = [];
    String? response;
    print('starting...');
    await http
        .get(Uri.parse(
            'https://api.github.com/search/repositories?o=desc&q=$query&s=stars'))
        .then((value) => response = value.body);
    Map<String, dynamic> map = json.decode(response!);
    List<dynamic> items = map['items'];
    for (int i = 0; i < items.length; i++) {
      print(items[i]);
      _result.add(_gitHubModel.fromJson(items[i]));
    }
    return _result;
  }
}
