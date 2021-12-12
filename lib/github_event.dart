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
  DeleteItemsEvent(this.listItems);
  List<int> listItems;
  @override
  List<Object?> get props => [listItems];
}