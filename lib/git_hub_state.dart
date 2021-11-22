import 'package:equatable/equatable.dart';

abstract class GitHubState extends Equatable {}

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
  final error;

  GitHubError({this.error});

  @override
  List<Object?> get props => [];
}
