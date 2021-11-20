



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/git_hub_state.dart';
import 'package:github_flutter_app/github_client.dart';

import 'git_hub_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState>{
  GitHubClient gitHubClient = GitHubClient();

  GitHubBloc() : super(GitHubInitial()) {
    on<LoadingEvent>((event, emit) async {
      List<List<dynamic>> _loadedItemsList = await gitHubClient.getItems(
          event.text);
      emit(GitHubLoaded(loadedItems: _loadedItemsList));
    });

  }
}
