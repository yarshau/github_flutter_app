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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white12,
          resizeToAvoidBottomInset: true,
          body: GitHubPage(),
        ),
      ),
    );
  }


}
