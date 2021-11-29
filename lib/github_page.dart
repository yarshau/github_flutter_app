import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_bloc.dart';
import 'package:github_flutter_app/github_event.dart';
import 'package:github_flutter_app/github_model.dart';
import 'package:github_flutter_app/github_state.dart';

class GitHubPage extends StatefulWidget {
  GitHubPage({Key? key}) : super(key: key);

  @override
  _GitHubPageState createState() => _GitHubPageState();
}

class _GitHubPageState extends State<GitHubPage> {
  late List<dynamic> t;
  final _controller = TextEditingController();

  final GitHubBloc gitHubBloc = GitHubBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GitHubBloc(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 25,
              ),
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
                      gitHubBloc.add(LoadedEvent(_controller.text));
                    } else {
                      return _showSnack(context);
                    }
                  },
                ),
              ),
              Flexible(fit: FlexFit.loose, child: _buildRepoList(context))
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('The Search cannot be empty'),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildRepoList(BuildContext context) {
    return BlocBuilder<GitHubBloc, GitHubState>(
        bloc: gitHubBloc,
        builder: (BuildContext context, state) {
          print('$state');
          if (state is GitHubEmptyState) {
            return Center(child: Text('Press on the Search button'));
          } else if (state is GitHubInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Loading in progress...')
              ],
            );
          } else if (state is GitHubLoaded && state.loadedItems.isNotEmpty) {
            final List<RepoInfo> list = state.loadedItems;
            print(list.first);
            return Column(
              children: list
                  .map((item) => ListTile(
                        title: Text('Name: ${item.name}'),
                        subtitle: Text('Id: ${item.id}'),
                        trailing: Text('Url: ${item.gitUrl}'),
                        leading: Image.network('${item.avatarUrl}'),
                      ))
                  .toList(),
            );
          } else if (state is GitHubError) {
            return Container(
              child: Column(
                children: [
                  Text('The status code is: ${state.statusCode}'),
                  Text('The reason is: ${state.reason}'),
                ],
              ),
            );
          } else {
            // how to
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/no_data_found.png'),
                  Text('No data was found on GitHub with this Search input'),
                ],
              ),
            );
          }
        });
  }
}
