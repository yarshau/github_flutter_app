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
                    gitHubBloc.add(LoadingEvent(_controller.text));
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
            } else if (state is GitHubError) {
              return Container(
                child: Center(child: Text('${state.error}')),
              );
            } else {
              return Container(
                child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        Image.asset('assets/no_data_found.png'),
                        Text(
                            'No data was found on GitHub with this Search input'),
                      ],
                    )),
              );
            }
          }),
    );
  }
}
