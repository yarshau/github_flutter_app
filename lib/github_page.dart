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

//  final GitHubBloc gitHubBloc = GitHubBloc();
  List<int> listToDelete = [];
  bool _isVisible = false;

//  late List<String> _children = [];

  @override
  Widget build(BuildContext context) {
    void _checkAll(bool value) {
      final githubState = context.read<GitHubBloc>().state as GitHubLoaded;
      List<RepoInfo> list = githubState.loadedItems;
      _checkAllItems = value;
      if (_checkAllItems) {
        print('loaded items ${list.map((e) => e.id)}');
        setState(() {
          listToDelete.addAll(list.map((e) => e.id));
        });
        print('_checkAll $value');
        print('listtodelete ::: $listToDelete');
      } else {
        print('remoooooove $value');
        setState(() {
          listToDelete.clear();
          _checkAllItems = false;
        });
      }
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
                                  .add(DeleteItemsEvent(listToDelete));
                              _deleteSnack(context, listToDelete);
// the       listToDelete.clear(); is deleted all items before event starting
//                              listToDelete.clear();
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

  Widget _buildRepoList(BuildContext context) {
    return BlocBuilder<GitHubBloc, GitHubState>(
        bloc: BlocProvider.of(context),
        builder: (BuildContext context, state) {
          print('rebuilded state : $state');
          if (state is GitHubEmptyState) {
            return Center(child: Text('Press on the Search button'));
          } else if (state is GitHubLoaded) {
            final List<RepoInfo> list = state.loadedItems;
//            _checkAll(_checkAllItems, state);
            int _count = 1;
            print(list.first.name);
            return Column(
              children: list
                  .map(
                    (item) => ListTile(
                      title: Text('${_count++}. Name: ${item.name}'),
                      subtitle: Column(children: [
                        Text('Id: ${item.id}'),
                        Text('Url: ${item.gitUrl}')
                      ]),
                      trailing: Checkbox(
                          value: listToDelete.contains(item.id),
                          onChanged: (_value) {
                            setState(() {
                              item.checkToDelete = _value!;
                              _value
                                  ? listToDelete.add(item.id)
                                  : listToDelete.remove(item.id);
                              print('_isVisible $_isVisible');
                              listToDelete.isEmpty
                                  ? _isVisible = false
                                  : _isVisible = true;
                              print('listToDelete $listToDelete');
                              print('_isVisible $_isVisible');
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

  void onTapped(bool i) {
    setState(
      () {
        _checkAllItems = i;
      },
    );
  }
//  checkAllItemsMap() {}
}
