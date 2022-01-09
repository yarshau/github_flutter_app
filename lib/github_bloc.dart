import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  final GitHubClient gitHubClient;
  final GitHubRepository gitHubRepository;
  List<int> _listToDelete1 = [];
  List<RepoInfo> loadedItems = [];
  bool isVisible = false;
  bool checkAllItems = false;

  GitHubBloc(this.gitHubClient, this.gitHubRepository)
      : super(GitHubEmptyState()) {
    gitHubRepository.subscribeOnUpdates().then(
          (stream) =>
          stream.listen((items) {
            loadedItems = items;
            print('items from subscribeOn : $items');
            if (items.isEmpty) {
              emit(GitHubEmptyState());
            } else {
              emit(GitHubLoaded(
                  loadedItems: items,
                  listToDelete: _listToDelete1));
            }
          }),
    );

    on<LoadedEvent>((event, emit) async {
      emit (GitHubInitial());
      GitHubResponse _response = await gitHubClient.getItems(event.text);
      if (_response is ResponseSuccess) {
        gitHubRepository.insert(_response.items);
      } else if (_response is ResponseError) {
        emit(GitHubError(
            reason: _response.reasonPhrase, statusCode: _response.statusCode));
      }
    });

// if no internet connection - the images won't displayed
    on<InitEvent>((event, emit) async {
      emit(GitHubEmptyState());
    });

    on<DeleteItemsEvent>((event, emit) async {
      await gitHubRepository.deleteSelected(_listToDelete1);
      _listToDelete1.clear();
      isVisible = false;
    });

    on<MarkCheckboxEvent>((event, emit) {
      if (_listToDelete1.contains(event.id)) {
        _listToDelete1.remove(event.id);
      } else {
        _listToDelete1.add(event.id);
      }
      _listToDelete1.isNotEmpty ? isVisible = true : isVisible = false;
      checkAllItems ? checkAllItems = false : null;
      emit(GitHubLoaded(loadedItems: loadedItems,
          listToDelete: _listToDelete1));
      print('_listToDelete1 $_listToDelete1');
    });

    on<MarkAllCheckboxEvent>((event, emit) async {
      if (checkAllItems) {
        checkAllItems = false;
        _listToDelete1.clear();
      } else {
        checkAllItems = true;
        _listToDelete1 = loadedItems.map((item) => item.id).toList();
      }
      _listToDelete1.isNotEmpty ? isVisible = true : isVisible = false;
      emit(GitHubLoaded(loadedItems: loadedItems,
          listToDelete: _listToDelete1,
      ));
      print('_listToDELETE: $_listToDelete1');
    });
  }
}
