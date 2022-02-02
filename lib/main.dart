import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:github_flutter_app/chatting/chatting_screen.dart';
import 'package:github_flutter_app/chatting/create_user/create_user_page.dart';
import 'package:github_flutter_app/my_drawer.dart';
import 'package:provider/provider.dart';
import 'api/github_client.dart';
import 'chatting/login/auth_service.dart';
import 'chatting/login/login_page.dart';
import 'db/github_repository.dart';
import 'list_github/github_list_page.dart';

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
          Provider<AuthService>(create: (_) => AuthService()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            'login_screen': (context) => LoginPage(),
            'chatting_screen': (context) => ChattingScreen(),
            'sign_up_screen': (context) => CreateUserPage(),
            'git_hub_screen': (context) => GitHubPage()
          },
         home: MyApp()
        ));
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  List<Widget> list = [LoginPage(), GitHubPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messenger')),
      drawer: MyDrawer(
        onTap: (ctx, int i) {
          setState(() {
            index = i;
            Navigator.pop(ctx);
          });
        },
      ),
      body: list[index],
    );
  }
}
