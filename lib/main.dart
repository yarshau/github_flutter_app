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
    return MultiProvider(
      providers: [
        Provider<GitHubClient>(create: (_) => GitHubClient()),
        Provider<GitHubRepository>(create: (_) => GitHubRepository()),
        ChangeNotifierProvider<MyProvider>.value(value: MyProvider()),
//        ChangeNotifierProvider<MyProvider>(create:(_)=> MyProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.lime,
          body: GitHubPage(),
        ),
      ),
    );
  }
}
