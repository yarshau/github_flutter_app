import 'package:github_flutter_app/github_model.dart';

abstract class GitHubState{
  const GitHubState();
  List<Object?> get props => [];

}

class GitHubEmptyState extends GitHubState {
  @override
  List<Object?> get props => [];
}

class GitHubInitial extends GitHubState {
  @override
  List<Object?> get props => [];
}

class GitHubLoaded extends GitHubState {
  final List<RepoInfo> loadedItems;
  final List<int> listToDelete;

  GitHubLoaded({required this.loadedItems, required this.listToDelete});

  @override
  List<Object?> get props => [loadedItems, listToDelete];
}

class GitHubError extends GitHubState {
  final String reason;
  final int statusCode;

  GitHubError({required this.reason, required this.statusCode});

  @override
  List<Object?> get props => [];
}
