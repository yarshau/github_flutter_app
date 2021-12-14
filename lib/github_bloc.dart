import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_page.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  GitHubClient gitHubClient = GitHubClient();
  GitHubRepository gitHubRepository = GitHubRepository();
  GitHubPage gitHubPage = GitHubPage();

  GitHubBloc() : super(GitHubEmptyState()) {
    gitHubRepository.isDatabaseInitialized.stream.listen((event) {
      event ? _subscribeToUpUpdates() : Future.value();
    });

    on<LoadedEvent>((event, emit) async {
      GitHubResponse _response = await gitHubClient.getItems(event.text);
      if (_response is ResponseSuccess) {
        gitHubRepository.insert(_response.items);
      } else if (_response is ResponseError) {
        emit(GitHubError(
            reason: _response.reasonPhrase, statusCode: _response.statusCode));
      }
    });

// if no internet connection - not displayed the images
    on<InitEvent>((event, emit) async {
      emit(GitHubEmptyState());
    });


    on<DeleteItemsEvent>((event, emit) async {
      await gitHubRepository.deleteSelected(event.listItems);
    });
  }

  _subscribeToUpUpdates() {
    gitHubRepository
        .subscribeOnUpdates()
        .then((stream) =>
        stream.listen((items) {
          print('items from subscribeon : $items');
          if (items.isEmpty) {
            emit(GitHubEmptyState());
          } else {
            emit(GitHubLoaded(loadedItems: items));
          }
        }),);
  }
}
