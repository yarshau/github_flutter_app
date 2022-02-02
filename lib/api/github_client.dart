import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:github_flutter_app/api/github_model.dart';
import 'package:http/http.dart' as http;

class GitHubClient {
  Future<GitHubResponse> getItems(String query) async {
    print('starting... GitHubClient');
    final _connectivityResult = await (Connectivity().checkConnectivity());
    if (_connectivityResult == ConnectivityResult.mobile ||
        _connectivityResult == ConnectivityResult.wifi) {
      final _response = await http.get(Uri.parse(
          'https://api.github.com/search/repositories?o=desc&q=$query&s=stars'));
      if (_response.statusCode == 200) {
        final List<RepoInfo> _result = [];
        Map<dynamic, dynamic> _map = json.decode(_response.body);
        final List<dynamic> _items = _map['items'];
        for (int i = 0; i < _items.length; i++) {
          Map<String, dynamic> ownerMap = _items[i]['owner'];
          final image = await http.get(Uri.parse(ownerMap['avatar_url']));
          ownerMap['avatar_url'] = image.bodyBytes.toString();
          print('result   ${_result}');
          _result.add(RepoInfo.fromJson(_items[i]));
        }
        return ResponseSuccess(_result);
      } else {
        final int _status = _response.statusCode;
        final String _reasonPhrase = _response.reasonPhrase ?? 'Not defined reason';
        return ResponseError(statusCode: _status, reasonPhrase: _reasonPhrase);
      }
    } else {
      return ResponseError(
          statusCode: 0, reasonPhrase: 'Check your internet connection');
    }
  }
}
