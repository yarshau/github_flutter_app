import 'package:github_flutter_app/github_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_model.dart';

class GitHubRepository {
  GitHubRepository();

  static const String tableGit = 'git';
  static final DatabaseProvider dbHelper = DatabaseProvider();

  Future<void> insert(List<RepoInfo> items) async {
    print('inside insert method');
    final db = await dbHelper.getDatabase;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(tableGit, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<void> clear() async {
    print('inside clear method');
    final db = await dbHelper.getDatabase;
    db.rawDelete('DELETE FROM git');
  }

  Future<List<RepoInfo>> getRepoInfo() async {
    final db = await dbHelper.getDatabase;
    final List<Map<String, dynamic>> database = await db.query(tableGit);
    List<RepoInfo> list = [];
    print('inside getRepoInfo method');
    database.forEach((element) {
      print(element);
      list.add(RepoInfo.fromDatabase(element));
    });
    print('inside getRepoInfo method222');
    return list;
  }
}
