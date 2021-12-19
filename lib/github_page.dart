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

  bool _checkAllItems = false;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    void _checkAll(bool value) {
      List<int> listToDelete = [];
      final githubState = context.read<GitHubBloc>().state as GitHubLoaded;
      List<RepoInfo> list = githubState.loadedItems;
      _checkAllItems = value;
      if (_checkAllItems) {
        list.forEach((element) {
          listToDelete.add(element.id);
        });
      } else {
        listToDelete.clear();
      }
      BlocProvider.of<GitHubBloc>(context)
          .add(MarkAllCheckboxEvent(listToDelete));
    }

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
            child: Stack(
              children: [
                Center(
                  child: TextButton(
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
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: _isVisible,
                        child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<GitHubBloc>(context)
                                  .add(DeleteItemsEvent());
                              _deleteSnack(
                                  context,
                                  BlocProvider.of<GitHubBloc>(context)
                                      .listToDelete1);
                              setState(() {
                                _isVisible = false;
                                _checkAllItems = false;
                              });
                            },
                            child: Text('Delete Selected')),
                      ),
                      Visibility(
                          visible: _isVisible,
                          child: Checkbox(
                              value: _checkAllItems,
                              onChanged: (value) {
                                print('value $value');
                                setState(() {
                                  _checkAll(value!);
                                });
                              }))
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(),
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

  sprint() async {
    print('sprint');
  }

  Widget _buildRepoList(BuildContext context) {
    return BlocBuilder<GitHubBloc, GitHubState>(
        bloc: BlocProvider.of(context),
        builder: (BuildContext context, state) {
          if (state is GitHubEmptyState) {
            return Center(child: Text('Press on the Search button'));
          } else if (state is GitHubLoaded) {
            final List<RepoInfo> list = state.loadedItems;
            int _count = 1;
            print(list.first.name);
            return Column(
              children: list
                  .map(
                    (item) => Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black))),
                      child: ListTile(
                        title: Text('${_count++}. Name: ${item.name}'),
                        subtitle: Column(children: [
                          Text('Id: ${item.id}'),
                          Text('Url: ${item.gitUrl}')
                        ]),
                        trailing: Checkbox(
                            value: BlocProvider.of<GitHubBloc>(context)
                                .listToDelete1
                                .contains(item.id),
                            onChanged: (_) async {
                              BlocProvider.of<GitHubBloc>(context)
                                  .add(MarkCheckboxEvent(item.id));
                             //                                                should be changed the next line
                              await sprint();
                              setState(() {
                                BlocProvider.of<GitHubBloc>(context)
                                        .listToDelete1
                                        .isNotEmpty
                                    ? _isVisible = true
                                    : _isVisible = false;
                                item.checkToDelete = !item.checkToDelete;
                              });
                              if (_checkAllItems) {
                                _checkAllItems = false;
                              }
                            }),
                        leading: Image.network('${item.avatarUrl}'),
                      ),
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
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text('No data was found on GitHub with this Search input'),
                  Image.asset('assets/no_data_found.png'),
                ],
              ),
            );
          }
        });
  }
}
