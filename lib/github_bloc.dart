import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_database.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:github_flutter_app/github_model.dart';

import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  GitHubClient gitHubClient = GitHubClient();
  GitHubRepository gitHubRepository = GitHubRepository();

  GitHubBloc() : super(GitHubEmptyState()) {
    on<LoadedEvent>((event, emit) async {
      emit(GitHubInitial());
      GitHubResponse _response = await gitHubClient.getItems(event.text);
      if (_response is ResponseSuccess) {
        gitHubRepository.clear();
        gitHubRepository.insert(_response.items);

        List<RepoInfo> itemsFromDB = await gitHubRepository.getRepoInfo();
        print('after dbHelper');

        emit(GitHubLoaded(loadedItems: itemsFromDB));
      } else if (_response is ResponseError) {
        emit(GitHubError(
            reason: _response.reasonPhrase, statusCode: _response.statusCode));
      }
    });
  }
}
