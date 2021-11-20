import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:http/http.dart' as http;

import 'github_page.dart';

void main() {
  runApp(Git());

//  GitHubClient temp = GitHubClient();
//  temp.a();

}

class Git extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GitHubPage(),
      ),
    );
  }
}
