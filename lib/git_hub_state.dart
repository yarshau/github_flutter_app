import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/github_model.dart';


abstract class GitHubState extends Equatable {

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
  final error;
  GitHubError({this.error});

  @override
  List<Object?> get props => [];
}