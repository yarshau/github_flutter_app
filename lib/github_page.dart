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
  final _controller = TextEditingController();

//  final GitHubBloc gitHubBloc = GitHubBloc();
  List<int> listToDelete = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Search'),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      BlocProvider.of<GitHubBloc>(context)
                          .add(LoadedEvent(_controller.text));
                    } else {
                      return _emptySnack(context);
                    }
                  },
                ),
                SizedBox(
                  width: 50,
                ),

                // how to hide this DELETE button if no checkbox selected yet    /////////////
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<GitHubBloc>(context)
                          .add(DeleteItemsEvent(listToDelete));
                      _deleteSnack(context, listToDelete);

                      // don't delete actually items if this work
//                     listToDelete.clear();
                    },
                    child: Text('Delete Selected')),
                Checkbox(value: false, onChanged: (value) {})
              ],
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: SingleChildScrollView(child: _buildRepoList(context))),
        ],
      ),
    );
  }

  void _deleteSnack(BuildContext context, list) {
    final snackBar = SnackBar(
      content: Text('The items with id:"${list.toString()}" was deleted! '),
      backgroundColor: Colors.lime,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _emptySnack(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('The Search cannot be empty'),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildRepoList(BuildContext context) {
    return BlocBuilder<GitHubBloc, GitHubState>(
        bloc: BlocProvider.of(context),
        builder: (BuildContext context, state) {
          print('rebuilded state : $state');
          if (state is GitHubEmptyState) {
            return Center(child: Text('Press on the Search button'));
          }
          // How not dublicate these code twice for GitHubLoaded and GitHubFromDb States    //////////////
          else if (state is GitHubLoaded && state.loadedItems.isNotEmpty) {
            final List<RepoInfo> list = state.loadedItems;
            int _count = 1;
            print(list.first.name);
            return Column(
              children: list
                  .map(
                    (item) => ListTile(
                      title: Text('${_count++} Name: ${item.name}'),
                      subtitle: Column(children: [
                        Text('Id: ${item.id}'),
                        Text('Url: ${item.gitUrl}')
                      ]),
                      trailing: Checkbox(
                          value: item.checkToDelete ?? false,
                          onChanged: (_value) {
                            setState(() {
                              item.checkToDelete = _value!;
                              if (_value == true) {
                                listToDelete.add(item.id);
                              } else {
                                listToDelete.remove(item.id);
                              }
                            });
                          }),
                      leading: Image.network('${item.avatarUrl}'),
                    ),
                  )
                  .toList(),
            );
          } else if (state is GitHubInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Loading in progress...')
              ],
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
          } else if (state is GitHubFromDb && state.itemsFromDB.isNotEmpty) {
            final List<RepoInfo> list = state.itemsFromDB;
            int _count = 1;
            return Column(
              children: list
                  .map(
                    (item) => ListTile(
                      title: Text('${_count++} Name: ${item.name}'),
                      subtitle: Column(children: [
                        Text('Id: ${item.id}'),
                        Text('Url: ${item.gitUrl}')
                      ]),
                      trailing: Checkbox(
                          value: item.checkToDelete ?? false,
                          onChanged: (_value) {
                            setState(() {
                              item.checkToDelete = _value!;
                              if (_value == true) {
                                listToDelete.add(item.id);
                              } else {
                                listToDelete.remove(item.id);
                              }
                            });
                          }),
                      leading: Image.network('${item.avatarUrl}'),
                    ),
                  )
                  .toList(),
            );
          } else {
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
