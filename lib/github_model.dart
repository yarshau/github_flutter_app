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

  GitHubModel({this.id, this.name, this.git_url, this.owner, this.avatar_url});

  fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    git_url = json['git_url'];
    owner = json['owner'];
    avatar_url = owner!['avatar_url'];
    List _res = [name, id, git_url, avatar_url];
    return _res;
  }
}
