import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'github_client.dart';
import 'github_page.dart';
import 'github_repository.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<GitHubClient>(create: (_) => GitHubClient()),
    Provider<GitHubRepository>(create: (_) => GitHubRepository()),
    ChangeNotifierProvider<MyProvider>.value(value: MyProvider())
  ], child: Git()));
}

class Git extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GitHubPage(),
    ));
  }
}
