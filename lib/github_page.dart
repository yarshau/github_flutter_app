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
        body:
            //how to make here SIngleChildScrollView ????????????????????????????????
            Column(
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
                    return showSnack(context);
                  }
                },
              ),
            ),
            buildRepoList(context)
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

  //how to make the same gitHubBloc instance if this widjet was in separate class??????
  Widget buildRepoList(BuildContext context) {
    return BlocBuilder<GitHubBloc, GitHubState>(
        bloc: gitHubBloc,
        builder: (BuildContext context, state) {
          print('$state');
          if (state is GitHubEmptyState) {
            return Center(child: Text('Press on the Search button'));
          } else if (state is GitHubInitial) {
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
            return Expanded(
              child: ListView.builder(
                itemCount: state.loadedItems.length - 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Name: ${state.loadedItems[index].name}'),
                    subtitle: Text('Id: ${state.loadedItems[index].id}'),
                    trailing: Text('Url: ${state.loadedItems[index].gitUrl}'),
                    leading:
                        Image.network('${state.loadedItems[index].avatarUrl}'),
                  );
                },
              ),
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
              // still overflowed is shown here , how to fix this ????
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
