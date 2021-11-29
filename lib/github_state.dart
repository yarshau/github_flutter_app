import 'package:equatable/equatable.dart';

abstract class GitHubState extends Equatable {}

class GitHubEmptyState extends GitHubState{
  @override
  List<Object?> get props => [];
}

class GitHubInitial extends GitHubState {
  @override
  List<Object?> get props => [];
}

class GitHubLoaded extends GitHubState {
  final List<List<dynamic>> loadedItems;

  GitHubLoaded({required this.loadedItems});

  @override
  List<Object?> get props => [loadedItems];
}

class GitHubError extends GitHubState {
  final String reason;
  final int statusCode;

  GitHubError({required this.reason, required this.statusCode});

  @override
  List<Object?> get props => [];
}
