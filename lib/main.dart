import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:github_flutter_app/login/login_page.dart';
import 'package:provider/provider.dart';
import 'github_client.dart';
import 'github_list_page.dart';
import 'github_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: LoginPage(),
        ),
      ),
    );
  }
}
