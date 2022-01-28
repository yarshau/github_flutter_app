import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_flutter_app/chatting/chatting_screen.dart';
import 'package:github_flutter_app/chatting/create_user/create_user_page.dart';
import 'package:github_flutter_app/login/auth_service.dart';
import 'package:github_flutter_app/login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api/github_client.dart';
import 'db/github_repository.dart';
import 'list_github/github_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(Git());
}

class Git extends StatefulWidget {
  @override
  _GitState createState() => _GitState();
}

class _GitState extends State<Git> {
  int index = 0;
  List<Widget> list = [GitHubPage(), LoginPage()];

//
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GitHubClient>(create: (_) => GitHubClient()),
        Provider<GitHubRepository>(create: (_) => GitHubRepository()),
        ChangeNotifierProvider<MyProvider>.value(value: MyProvider()),
        Provider<AuthService>(create: (_) => AuthService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'login_screen': (context) => LoginPage(),
          'chatting_screen': (context) => ChattingScreen(),
          'sign_up_screen': (context) => CreateUserPage(),
          'git_hub_screen': (context) => GitHubPage()
        },
        home: Scaffold(
          appBar: AppBar(title: Text('GitHub')),
          drawer: MyDrawer(onTap: (ctx, int i) {
            setState(() {
              index = i;
              Navigator.pop(ctx);
            });
          }),
          body: list[index],
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final Function onTap;

  const MyDrawer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        ListTile(title: Text('git_hub_screen'), onTap: () => onTap(context, 0)
            ),
        ListTile(
          title: Text('login_screen'),
          onTap: () => onTap(context, 1),
        ),
        Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () async {
                await launch('tel:<380968361508>');
              },
            ),
            IconButton(
              onPressed: () async {
                await launch('https://www.instagram.com/yar.shau/',
                    forceSafariVC: true);
              },
              icon: Icon(FontAwesomeIcons.instagram),
            ),
            IconButton(
                onPressed: () async {
                  await launch('https://github.com/yarshau/',
                      forceSafariVC: true);
                },
                icon: Icon(FontAwesomeIcons.github)),
            IconButton(
                onPressed: () async {
                  await launch('mailto:yarshau@gmail.com');
                },
                icon: Icon(Icons.mail_outline)),
          ],
        ),
        Text('Contacts'),
      ],
    ));
  }
}
