import 'dart:convert';

import 'package:github_flutter_app/github_model.dart';
import 'package:http/http.dart' as http;

class GitHubClient {
  GitHubModel _gitHubModel = GitHubModel();

  Future<List<List<dynamic>>> getItems(String query) async {
    final List<List<dynamic>> _result = [];
    String? response;
    print('starting...');
    Response response = await http.get(Uri.parse(
        'https://api.github.com/search/repositores?o=desc&q=$query&s=stars'));
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> _items = map['items'];
    List<dynamic> _header =[];
    _header.add(response.statusCode);
//    if (response.statusCode == 200) {
      for (int i = 0; i < _items.length; i++) {
        _result.add(GitHubModel.fromJson(_items[i]));
      }
      return _result;
//    } else {
//      print('eelse   ${response.statusCode}');
//      return header;
//    }
  }
}
