import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/details_github/details_page_widget.dart';
import 'package:github_flutter_app/list_github/bloc/github_bloc.dart';
import 'package:github_flutter_app/api/github_client.dart';
import 'package:github_flutter_app/list_github/bloc/github_event.dart';
import 'package:github_flutter_app/api/github_model.dart';
import 'package:github_flutter_app/db/github_repository.dart';
import 'package:github_flutter_app/list_github/bloc/github_state.dart';
import 'dart:convert';

class GitHubPage extends StatefulWidget {
  GitHubPage({Key? key}) : super(key: key);

  @override
  GitHubPageState createState() => GitHubPageState();
}

class GitHubPageState extends State<GitHubPage> {
  final _controller = TextEditingController();
  late final GitHubBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GitHubBloc(context.read<GitHubClient>(), context.read<GitHubRepository>());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GitHub Flutter App')),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          _buildSearch(),
          const SizedBox(height: 5),
          Expanded(
            child: BlocProvider<GitHubBloc>(
              create: (BuildContext context) => _bloc,
              lazy: true,
              child: BlocBuilder<GitHubBloc, GitHubState>(
                  bloc: _bloc,
                  builder: (BuildContext context, state) {
                    print('state $state');
                    if (state is GitHubEmptyState) {
                      return Column(children: [
                        _showPage(),
                        Text('Press on the Search button'),
                      ]);
                    } else if (state is GitHubInitial) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35,
                          ),
                          CircularProgressIndicator(),
                          Text('Loading in progress...')
                        ],
                      );
                    } else if (state is GitHubLoaded) {
                      List<RepoInfo> list = state.loadedItems;
                      return Column(
                        children: [
                          Container(child: _showPage(state.listToDelete)),
                          Expanded(
                            child: _buildRepoList(list, state.listToDelete),
                          )
                        ],
                      );
                    } else if (state is GitHubError) {
                      return Container(
                        child: Column(
                          children: [
                            _showPage(),
                            Text('The status code is: ${state.statusCode}'),
                            Text('The reason is: ${state.reason}'),
                          ],
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _showPage(),
                            Text('No data was found on GitHub with this Search input'),
                            Image.asset('assets/no_data_found.png'),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepoList(List<RepoInfo> list, List<int> listToDelete) {
    int _count = 1;
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: list
          .map(
            (item) => Container(
              color: Colors.grey,
              child: Card(
                child: ListTile(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DetailsPage(
                          id: item.id,
                          name: item.name,
                        ),
                      ),
                    );
                  },
                  title: Text('${_count++}. Name: ${item.name}'),
                  subtitle: Column(children: [Text('Id: ${item.id}'), Text('Url: ${item.gitUrl}')]),
                  trailing: Checkbox(
                      value: listToDelete.contains(item.id),
                      onChanged: (_) {
                        _bloc.add(MarkCheckboxEvent(item.id));
                        item.checkToDelete = !item.checkToDelete;
                        print('listTOODELETE $listToDelete');
                      }),
                  leading: Image.memory(
                    Uint8List.fromList(json.decode(item.avatarUrl).cast<int>()),
                    key: Key(item.avatarUrl),
                    gaplessPlayback: true,
                  ),
                  contentPadding: EdgeInsets.all(2),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _showPage([List<int> listToDelete = const []]) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: _bloc.isVisible,
                child: ElevatedButton(
                    onPressed: () {
                      _bloc.add(DeleteItemsEvent());
                      _deleteSnack(context, listToDelete);
                    },
                    child: Text('Delete Selected')),
              ),
              Visibility(
                  visible: _bloc.isVisible,
                  child: Checkbox(
                      value: _bloc.checkAllItems,
                      onChanged: (value) {
                        print('value $value');
                        _bloc.add(MarkAllCheckboxEvent());
                      })),
              const SizedBox(width: 15),
            ],
          ),
        )
      ],
    );
  }

  void _deleteSnack(BuildContext context, List<int> list) {
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

  Widget _buildSearch() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Flexible(
            fit: FlexFit.tight,
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                  labelText: 'Input Repos name',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search_rounded),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _bloc.add(LoadedEvent(_controller.text));
                      } else {
                        return _emptySnack(context);
                      }
                    },
                  )),
              controller: _controller,
            )),
        SizedBox(width: 20)
      ],
    );
  }
}
