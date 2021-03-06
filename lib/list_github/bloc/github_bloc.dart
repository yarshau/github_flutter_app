import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/db/github_repository.dart';
import 'package:github_flutter_app/list_github/bloc/github_state.dart';
import 'package:github_flutter_app/api/github_client.dart';
import 'package:github_flutter_app/api/github_model.dart';
import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  final GitHubClient _gitHubClient;
  final GitHubRepository _gitHubRepository;
  List<int> _listToDelete1 = [];
  List<RepoInfo> _loadedItems = [];
  bool isVisible = false;
  bool checkAllItems = false;

  GitHubBloc(this._gitHubClient, this._gitHubRepository) : super(GitHubEmptyState()) {
    _gitHubRepository.subscribeOnUpdates().then(
          (stream) => stream.listen((items) {
            _loadedItems = items;
            print('items from subscribeOn : $items');
            if (items.isEmpty) {
              emit(GitHubEmptyState());
            } else {
              emit(GitHubLoaded(loadedItems: items, listToDelete: _listToDelete1));
            }
          }),
        );

    on<LoadedEvent>((event, emit) async {
      if (_loadedItems.isEmpty) {
        emit(GitHubInitial());
      }
      GitHubResponse _response = await _gitHubClient.getItems(event.text);
      if (_response is ResponseSuccess) {
        _gitHubRepository.insert(_response.items);
      } else if (_response is ResponseError) {
        emit(GitHubError(reason: _response.reasonPhrase, statusCode: _response.statusCode));
      }
    });

    on<InitEvent>((event, emit) async {
      emit(GitHubEmptyState());
    });

    on<DeleteItemsEvent>((event, emit) async {
      await _gitHubRepository.deleteSelected(_listToDelete1);
      _listToDelete1.clear();
      isVisible = false;
    });

    on<MarkCheckboxEvent>((event, emit) {
      if (_listToDelete1.contains(event.id)) {
        _listToDelete1.remove(event.id);
      } else {
        _listToDelete1.add(event.id);
      }
      isVisible = _listToDelete1.isNotEmpty;
      checkAllItems = !checkAllItems;
      emit(GitHubLoaded(loadedItems: _loadedItems, listToDelete: _listToDelete1));
      print('_listToDelete1 $_listToDelete1');
    });

    on<MarkAllCheckboxEvent>((event, emit) async {
      if (checkAllItems) {
        checkAllItems = false;
        _listToDelete1.clear();
      } else {
        checkAllItems = true;
        _listToDelete1 = _loadedItems.map((item) => item.id).toList();
      }
      _listToDelete1.isNotEmpty ? isVisible = true : isVisible = false;
      emit(GitHubLoaded(
        loadedItems: _loadedItems,
        listToDelete: _listToDelete1,
      ));
      print('_listToDELETE: $_listToDelete1');
    });
  }
}
