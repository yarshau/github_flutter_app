import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_page.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:github_flutter_app/github_state.dart';
import 'package:github_flutter_app/github_client.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_event.dart';

class GitHubBloc extends Bloc<GitHubEvents, GitHubState> {
  final GitHubClient gitHubClient = GitHubClient();
  final GitHubRepository gitHubRepository = GitHubRepository();
  final GitHubPage gitHubPage = GitHubPage();
  List<int> listToDelete1 = [];
  bool isVisible1 = false;

  GitHubBloc() : super(GitHubEmptyState()) {
    gitHubRepository.subscribeOnUpdates().then(
          (stream) => stream.listen((items) {
            print('items from subscribeOn : $items');
            if (items.isEmpty) {
              emit(GitHubEmptyState());
            } else {
              emit(GitHubLoaded(loadedItems: items));
              on<MarkAllCheckboxEvent>(event, emit) {
                items.forEach((element) {
                  listToDelete1.add(element.id);
                });
              }
            }
          }),
        );

    on<LoadedEvent>((event, emit) async {
      GitHubResponse _response = await gitHubClient.getItems(event.text);
      if (_response is ResponseSuccess) {
        gitHubRepository.insert(_response.items);
      } else if (_response is ResponseError) {
        emit(GitHubError(
            reason: _response.reasonPhrase, statusCode: _response.statusCode));
      }
    });

// if no internet connection - don't displayed the images
    on<InitEvent>((event, emit) async {
      emit(GitHubEmptyState());
    });

    on<DeleteItemsEvent>((event, emit) async {
      await gitHubRepository.deleteSelected(listToDelete1);
      listToDelete1.clear();
    });

    on<MarkCheckboxEvent>((event, emit) {
      if (listToDelete1.contains(event.id)) {
        listToDelete1.remove(event.id);
      } else {
        listToDelete1.add(event.id);
      }
      print('listToDelete1 $listToDelete1');
    });

    on<MarkAllCheckboxEvent>((event, emit) {
      listToDelete1.clear();
      listToDelete1.addAll(event.list);

      print('listToDELETE: $listToDelete1');
    });
  }
}
