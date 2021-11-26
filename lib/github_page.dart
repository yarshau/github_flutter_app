import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/git_hub_bloc.dart';
import 'package:github_flutter_app/git_hub_event.dart';
import 'package:github_flutter_app/git_hub_state.dart';
import 'package:github_flutter_app/github_client.dart';

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 550,
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Input Repos name',
                    prefixIcon: Icon(Icons.search_rounded),
                    border: OutlineInputBorder()),
                controller: _controller,
              ),
            ),
            Center(
              child: TextButton(
                child: Text('Search'),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    showDialog(context: context, builder: alert);
                    gitHubBloc.add(LoadedEvent(_controller.text));
                  } else {
                    return showSnack(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnack(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('The Search cannot be empty'),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget alert(BuildContext context) {
    int count = 0;
    return Material(
      child: BlocBuilder<GitHubBloc, GitHubState>(
          bloc: gitHubBloc,
          builder: (BuildContext context, state) {
            if (state is GitHubInitial) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Loading in progress...')
                ],
              ));
            } else if (state is GitHubLoaded && state.loadedItems.isNotEmpty) {
              final List<RepoInfo> list = state.loadedItems;
              print(list.first);
              return ListView.builder(
                  itemCount: state.loadedItems.length - 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Name: ${state.loadedItems[index].name}'),
                      subtitle:
                          Text('Id: ${state.loadedItems[index].id} ${count++}'),
                      trailing: Text('Url: ${state.loadedItems[index].gitUrl}'),
                      leading: Image.network(
                          '${state.loadedItems[index].avatarUrl}'),
                    );
                  });
            } else if (state is GitHubError) {
              return Container(
                child: Center(child: Text('${state.reason}')),
              );
            } else {
              return SingleChildScrollView(
                child: Container(
                  child: Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Image.asset('assets/no_data_found.png'),
                      Text(
                          'No data was found on GitHub with this Search input'),
                    ],
                  )),
                ),
              );
            }
          }),
    );
  }
}
