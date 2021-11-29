abstract class GitHubResponse {}

class ResponseError extends GitHubResponse {
  ResponseError({required this.statusCode, required this.reasonPhrase});

  final int statusCode;
  final String reasonPhrase;
}

class ResponseSuccess extends GitHubResponse{
  final List<RepoInfo> items;

  ResponseSuccess(this.items);
}

class RepoInfo extends GitHubResponse {
  RepoInfo({
    required this.id,
    required this.name,
    required this.gitUrl,
    required this.owner,
    required this.avatarUrl,
  });

  final int id;
  final String name;
  final String gitUrl;
  final String avatarUrl;
  final Map owner;

  factory RepoInfo.fromJson(Map<dynamic, dynamic> json) {
    return RepoInfo(
      id: json['id'],
      name: json['name'],
      gitUrl: json['git_url'],
      owner: json['owner'],
      avatarUrl: json['owner']['avatar_url'],
    );
  }
}
