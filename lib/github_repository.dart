import 'package:github_flutter_app/github_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

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
    db.rawDelete('DELETE FROM $tableGit');
  }

  Future<List<RepoInfo>> getRepoInfo() async {
    final db = await dbHelper.getDatabase;
    final List<Map<String, dynamic>> listMaps = await db.query(tableGit);
    List<RepoInfo> list = [];
    listMaps.forEach((element) {
      list.add(RepoInfo.fromDatabase(element));
    });
    subscribeOnUpdates();
    return list;
  }

  Future<bool> isNotEmpty() async {
    final db = await dbHelper.getDatabase;
    final List<Map<String, dynamic>> listMaps = await db.query(tableGit);
    final bool isNotEmpty = listMaps.isNotEmpty;
    return isNotEmpty;
  }

  Future<Stream<List<RepoInfo>>> subscribeOnUpdates() async {
    final db = await dbHelper.getDatabase;
    var streamDb = BriteDatabase(db);
    return streamDb.createQuery(tableGit).mapToList((row) => RepoInfo(
        avatarUrl: row['avatarUrl'],
        id: row['id'],
        name: row['name'],
        gitUrl: row['gitUrl']));
  }

  Future<void> deleteSelected(List list) async {
    print('list to DELETE ${list.length}');
    final db = await dbHelper.getDatabase;
    list.forEach((element) {
      db.delete(tableGit, where: 'ID = $element');
    });
  }
}
