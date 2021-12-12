import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_bloc.dart';

import 'github_page.dart';

void main() {
  runApp(Git());
}

class Git extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GitHubBloc>(
        create: (BuildContext context) => GitHubBloc(),
        lazy: false,
        child: MaterialApp(
          home: Scaffold(
            body: GitHubPage(),
          ),
        ));
  }
}
