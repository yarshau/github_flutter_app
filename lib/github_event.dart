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

class DeleteItemsEvent extends GitHubEvents {
  @override
  List<Object?> get props => [];
}

class MarkCheckboxEvent extends GitHubEvents {
  MarkCheckboxEvent(this.id);

  int id;

  @override
  List<Object?> get props => [];
}

class MarkAllCheckboxEvent extends GitHubEvents {
  MarkAllCheckboxEvent(this.list);
  List<int> list;
  @override
  List<Object?> get props => [list];
}
