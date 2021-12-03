import 'dart:convert';
import 'package:github_flutter_app/github_model.dart';
import 'package:http/http.dart' as http;

class GitHubClient {

  Future<GitHubResponse> getItems(String query) async {
    print('starting...');
    final _response = await http.get(Uri.parse(
        'https://api.github.com/search/repositories?o=desc&q=$query&s=stars'));
    if (_response.statusCode == 200) {
      final List<RepoInfo> _result = [];
      Map<dynamic, dynamic> _map = json.decode(_response.body);
      List<dynamic> _items = _map['items'];
      for (int i = 0; i < _items.length; i++) {
        _result.add(RepoInfo.fromJson(_items[i]));
      }
      return ResponseSuccess(_result);
    } else {
      int _status = _response.statusCode;
      String _reasonPhrase = _response.reasonPhrase ?? 'Not defined reason';
      return ResponseError(statusCode: _status, reasonPhrase: _reasonPhrase);
    }
  }
}
