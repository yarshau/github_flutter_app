class GitHubModel {
  int? id;
  String? name;
  String? git_url;
  String? avatar_url;
  Map? owner;

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
