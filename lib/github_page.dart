import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_bloc.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:github_flutter_app/github_event.dart';
import 'package:github_flutter_app/github_model.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:provider/provider.dart';

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
    _bloc = GitHubBloc(
        context.read<GitHubClient>(), context.read<GitHubRepository>());
  }

  @override
  Widget build(BuildContext context) {
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

    Widget _buildRepoList(List<RepoInfo> list, List<int> listToDelete) {
      int _count = 1;
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: list
            .map(
              (item) => Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: ListTile(
                  title: Text('${_count++}. Name: ${item.name}'),
                  subtitle: Column(children: [
                    Text('Id: ${item.id}'),
                    Text('Url: ${item.gitUrl}')
                  ]),
                  trailing: Checkbox(
                      value: listToDelete.contains(item.id),
                      onChanged: (_) {
                        _bloc.add(MarkCheckboxEvent(item.id));
                        item.checkToDelete = !item.checkToDelete;
                        print('listTOODELETE $listToDelete');
                      }),
                  leading: Image.network('${item.avatarUrl}'),
                ),
              ),
            )
            .toList(),
      );
    }

    Widget showPage(List<int> listToDelete) {
      return Stack(
        children: [
          Center(
            child: TextButton(
              child: Text('Search'),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _bloc.add(LoadedEvent(_controller.text));
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
                SizedBox(width: 15),
              ],
            ),
          )
        ],
      );
    }

    MyProvider myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text('${myProvider.str}')),
        body: BlocProvider<GitHubBloc>(
            create: (BuildContext context) => _bloc,
            lazy: false,
            child: Column(children: <Widget>[
              Container(
                  width: 550,
                  child: TextField(
                    onChanged: (newData) {
                      myProvider.changedField(newData);
                    },
                    decoration: InputDecoration(
                        labelText: 'Input Repos name',
                        prefixIcon: Icon(Icons.search_rounded),
                        border: OutlineInputBorder()),
                    controller: _controller,
                  )),
              Expanded(
                child: BlocBuilder<GitHubBloc, GitHubState>(
                    bloc: _bloc,
                    builder: (BuildContext context, state) {
                      print('state $state');
                      if (state is GitHubEmptyState) {
                        return Column(children: [
                          showPage([]),
                          Text('Press on the Search button'),
                        ]);
                      } else if (state is GitHubLoaded) {
                        List<RepoInfo> list = state.loadedItems;
                        return Column(
                          children: [
                            Container(
                                height: 50,
                                child: showPage(state.listToDelete)),
                            Expanded(
                              child: _buildRepoList(list, state.listToDelete),
                            )
                          ],
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
                              showPage([]),
                              Text('The status code is: ${state.statusCode}'),
                              Text('The reason is: ${state.reason}'),
                            ],
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              showPage([]),
                              Text(
                                  'No data was found on GitHub with this Search input'),
                              Image.asset('assets/no_data_found.png'),
                            ],
                          ),
                        );
                      }
                    }),
              )
            ])));
  }
}

class MyProvider extends ChangeNotifier {
  String _appBarString = 'Changed Text';

  String get str => _appBarString;

  changedField(String inputString) {
    _appBarString = inputString;
    notifyListeners();
  }
}
