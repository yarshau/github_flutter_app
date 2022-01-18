abstract class GitHubResponse {}

class ResponseError extends GitHubResponse {
  ResponseError({required this.statusCode, required this.reasonPhrase});

  final int statusCode;
  final String reasonPhrase;
}

class ResponseSuccess extends GitHubResponse {
  final List<RepoInfo> items;

  ResponseSuccess(this.items);

  final List<RepoInfo> items;
}

class RepoInfo extends GitHubResponse {
  RepoInfo({
    required this.login,
    required this.fullName,
    required this.organizationsUrl,
    this.license,
    this.licenseName,
    this.language,
    this.description,
    required this.url,
    required this.createdDate,
    required this.watchers,
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
  String avatarUrl;
  final Map? owner;
  final String login;
  final String fullName;
  final String organizationsUrl;
  final Map? license;
  final String? licenseName;
  final String? language;
  final String? description;
  final String url;
  final String createdDate;
  final int watchers;
  bool checkToDelete;

  factory RepoInfo.fromJson(Map<String, dynamic> json) {
    return RepoInfo(
      id: json['id'],
      name: json['name'],
      gitUrl: json['git_url'],
      owner: json['owner'],
      avatarUrl: json['owner']['avatar_url'],
      login: json['owner']['login'],
      fullName: json['full_name'],
      organizationsUrl: json['owner']['organizations_url'],
      license: json['license'],
      licenseName: json['owner']['type'],
      language: json['language'],
      description: json['description'],
      url: json['url'],
      createdDate: json['created_at'],
      watchers: json['watchers'],
      checkToDelete: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gitUrl': gitUrl,
      'avatarUrl': avatarUrl,
      'login': login,
      'fullName': fullName,
      'organizationsUrl': organizationsUrl,
      'licenseName': licenseName,
      'language': language,
      'description': description,
      'url': url,
      'createdDate': createdDate,
      'watchers': watchers
    };
  }

  factory RepoInfo.fromDatabase(Map<String, dynamic> map) {
    return RepoInfo(
        id: map['id'],
        name: map['name'],
        gitUrl: map['gitUrl'],
        avatarUrl: map['avatarUrl'],
        login: map['login'],
        fullName: map['fullName'],
        organizationsUrl: map['organizationsUrl'],
        license: map['license'],
        licenseName: map['type'],
        language: map['language'],
        description: map['description'],
        url: map['url'],
        createdDate: map['createdDate'],
        watchers: map['watchers'],
        checkToDelete: false);
  }
}
