import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:github_flutter_app/github_client.dart';

import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  GitHubClient gitHubClient = GitHubClient();

  GitHubBloc() : super(GitHubEmptyState()) {
    on<LoadedEvent>((event, emit) async {
      emit(GitHubInitial());
      GitHubResponse _response = await gitHubClient.getItems(event.text);
      if (_response is ResponseSuccess) {
        emit(GitHubLoaded(loadedItems: _response.items));
      } else if (_response is ResponseError) {
        emit(GitHubError(reason: _response.reasonPhrase, statusCode: _response.statusCode));
      }
    });
  }

//  void search(String query) async {
//    List<GitHubModel> _loadedItemsList = await gitHubClient.getItems(query);
//
//    emit(GitHubLoaded(loadedItems: _loadedItemsList));
//  }

}
