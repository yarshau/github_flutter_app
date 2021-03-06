import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_flutter_app/chatting/login/login_page.dart';
import 'package:github_flutter_app/list_github/github_list_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MyScaffold extends StatefulWidget {
  MyScaffold();

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  int index = 0;
  List<Widget> list = [LoginPage(), GitHubPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('iaaa')),
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

class MyDrawer extends StatelessWidget {
  final Function onTap;

  const MyDrawer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        SizedBox(height: 50),
        ListTile(
          title: Text('login_screen'),
          onTap: () => onTap(context, 0),
        ),
        ListTile(title: Text('git_hub_screen'), onTap: () => onTap(context, 1)),
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
