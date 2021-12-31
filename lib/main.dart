import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'github_client.dart';
import 'github_list_page.dart';
import 'github_repository.dart';

void main() {
  runApp(Git());
}

class Git extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: MultiProvider(providers: [
      Provider<GitHubClient>(create: (_) => GitHubClient()),
      Provider<GitHubRepository>(create: (_) => GitHubRepository()),
      ChangeNotifierProvider<MyProvider>.value(value: MyProvider()),
    ], child: GitHubPage())));
  }
}
