import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:github_flutter_app/github_client.dart';

import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  GitHubClient gitHubClient = GitHubClient();

  GitHubBloc() : super(GitHubInitial()) {
    on<LoadedEvent>((event, emit) async {
      emit(GitHubInitial());
      try {
        List<GitHubModel> _loadedItemsList =
        await gitHubClient.getItems(event.text);
        emit(GitHubLoaded(loadedItems: _loadedItemsList));
      } catch (error){
        emit(GitHubError(reason: error));
      }
    });

  }

//  void search(String query) async {
//    List<GitHubModel> _loadedItemsList = await gitHubClient.getItems(query);
//
//    emit(GitHubLoaded(loadedItems: _loadedItemsList));
//  }

}
