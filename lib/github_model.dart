abstract class GitHubResponse {}

class ResponseError extends GitHubResponse {
  ResponseError({required this.statusCode, required this.reasonPhrase});

  final int statusCode;
  final String reasonPhrase;
}

class ResponseSuccess extends GitHubResponse {
  final List<RepoInfo> items;

  ResponseSuccess(this.items);
}

class RepoInfo extends GitHubResponse {
  RepoInfo({
    required this.id,
    required this.name,
    required this.gitUrl,
    this.owner,
    required this.avatarUrl,
    required this.checkToDelete,
  });

  final int id;
  final String name;
  final String gitUrl;
  final String avatarUrl;
  final Map? owner;
  bool checkToDelete;

  factory RepoInfo.fromJson(Map<String, dynamic> json) {
    return RepoInfo(
      id: json['id'],
      name: json['name'],
      gitUrl: json['git_url'],
      owner: json['owner'],
      avatarUrl: json['owner']['avatar_url'],
      checkToDelete: false
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'gitUrl': gitUrl, 'avatarUrl': avatarUrl};
  }

  factory RepoInfo.fromDatabase(Map<String, dynamic> map) {
    return RepoInfo(
      id: map['id'],
      name: map['name'],
      gitUrl: map['gitUrl'],
      avatarUrl: map['avatarUrl'],
      checkToDelete: false
    );
  }
}
