import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/git_hub_bloc.dart';
import 'package:github_flutter_app/git_hub_event.dart';
import 'package:github_flutter_app/git_hub_state.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:github_flutter_app/github_model.dart';

class GitHubPage extends StatefulWidget {
  GitHubPage({Key? key}) : super(key: key);

  @override
  _GitHubPageState createState() => _GitHubPageState();
}

class _GitHubPageState extends State<GitHubPage> {
  GitHubClient temp = GitHubClient();
  late List<dynamic> t;
  final _controller = TextEditingController();

  final GitHubBloc gitHubBloc = GitHubBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GitHubBloc(),
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
            child: Column(children: [
          TextField(
            controller: _controller,
          ),
          Center(
            child: TextButton(
              child: Text('Search'),
              onPressed: () async {
//                    t = await temp.getItems(_controller.text);
//                    print('ttttttt $t fgdbgsf');
                showDialog(context: context, builder: alert);
                gitHubBloc.add(LoadingEvent(_controller.text));
              },
            ),
          ),
        ])),
      ),
    );
  }

  Widget alert(BuildContext context) {
    int count = 0;
    return Material(
      child: BlocBuilder<GitHubBloc, GitHubState>(
          bloc: gitHubBloc,
          builder: (BuildContext context, state) {
            if (state is GitHubLoaded) {
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.loadedItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      key: UniqueKey(),
                      title: Text('Name: ${state.loadedItems[index][0]}'),
                      subtitle:
                          //how to make count not changable ???????????????????????????
                          Text('Id: ${state.loadedItems[index][1]} ${count++}'),
                      trailing: Text('Url: ${state.loadedItems[index][2]}'),
                      leading: Image.network('${state.loadedItems[index][3]}'),
                    );
                  });
            }
            if (state is GitHubError) {
              return Container(
                child: Center(child: Text('${state.error}')),
              );
            } else {
              return Container(
                child: Center(child: Text('No data here from bloc')),
              );
            }
          }),
    );
  }
}
