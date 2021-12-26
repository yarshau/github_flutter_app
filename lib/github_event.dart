
abstract class GitHubEvents {
  const GitHubEvents();
  List<Object?> get props => [];
}

class InitEvent extends GitHubEvents {
  @override
  List<Object?> get props => [];
}

class LoadedEvent extends GitHubEvents {
  const LoadedEvent(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

class DeleteItemsEvent extends GitHubEvents {
  @override
  List<Object?> get props => [];
}

class MarkCheckboxEvent extends GitHubEvents {
  MarkCheckboxEvent(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class MarkAllCheckboxEvent extends GitHubEvents {

  @override
  List<Object?> get props => [];
}
