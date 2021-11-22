import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'github_page.dart';

void main() {
  runApp(Git());
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
