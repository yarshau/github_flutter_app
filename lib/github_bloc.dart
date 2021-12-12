import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  GitHubClient gitHubClient = GitHubClient();
  GitHubRepository gitHubRepository = GitHubRepository();

  GitHubBloc() : super(GitHubEmptyState()) {
    super.on<InitEvent>((event, emit) async {
      if (await gitHubRepository.isNotEmpty()) {
        List<RepoInfo> itemsFromDB = await gitHubRepository.getRepoInfo();
        emit(GitHubLoaded(loadedItems: itemsFromDB));
      } else {
        GitHubEmptyState();
      }
    });

    on<LoadedEvent>((event, emit) async {
      GitHubResponse _response = await gitHubClient.getItems(event.text);
      if (_response is ResponseSuccess) {
        gitHubRepository.insert(_response.items);
        List<RepoInfo> _itemsFromDB = await gitHubRepository.getRepoInfo();
        emit(GitHubLoaded(loadedItems: _itemsFromDB));
      } else if (_response is ResponseError) {
        emit(GitHubError(
            reason: _response.reasonPhrase, statusCode: _response.statusCode));
      }
    });

    on<DeleteItemsEvent>((event, emit) async {
      gitHubRepository.deleteSelected(event.listItems);
      List<RepoInfo> _itemsFromDB = await gitHubRepository.getRepoInfo();
      print('_ITEMS FROM DB $_itemsFromDB');
      emit(GitHubFromDb(itemsFromDB: _itemsFromDB));
      print('_ITEMS FROM DB2 $_itemsFromDB');
    });
  }
}
