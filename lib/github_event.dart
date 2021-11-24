import 'package:equatable/equatable.dart';

abstract class GitHubEvents extends Equatable {}

class InitEvent extends GitHubEvents {
  @override
  List<Object?> get props => [];
}

class LoadedEvent extends GitHubEvents {
  LoadedEvent(this.text);

  String text;

  @override
  List<Object?> get props => [text];
}
