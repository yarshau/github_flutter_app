import 'dart:convert';
import 'package:github_flutter_app/github_model.dart';
import 'package:http/http.dart' as http;

class GitHubClient {
  Future<GitHubResponse> getItems(String query) async {
    print('starting...');
    final response = await http.get(Uri.parse(
        'https://api.github.com/search/repositories?o=desc&q=$query&s=stars'));
    if (response.statusCode == 200) {
      final List<RepoInfo> _result = [];
      Map<dynamic, dynamic> map = json.decode(response.body);
      List<dynamic> _items = map['items'];
      for (int i = 0; i < _items.length; i++) {
        _result.add(RepoInfo.fromJson(_items[i]));
      }
      return ResponseSuccess(_result);
    } else {
      int status = response.statusCode;
      String reasonPhrase = response.reasonPhrase ?? 'Not defined reason';
      return ResponseError(statusCode: status, reasonPhrase: reasonPhrase);
    }
  }
}
