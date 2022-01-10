import 'dart:async';
import 'package:github_flutter_app/github_database.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class GitHubRepository {
  static const String tableGit = 'git';
  static final DatabaseProvider dbHelper = DatabaseProvider();

  Future<void> insert(List<RepoInfo> items) async {
    print('inside insert method');
    List<Map> _existedId;
    final _briteDatabase = await dbHelper.getDatabase;
    final batch = _briteDatabase.batch();
    for (var item in items) {
      _existedId =
          await _briteDatabase.query(tableGit, where: 'id = ${item.id}');
      if (_existedId.isEmpty) {
        batch.insert(tableGit, item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    await batch.commit();
  }

  Future<Stream<List<RepoInfo>>> subscribeOnUpdates() async {
    final _briteDatabase = await dbHelper.getDatabase;

    return _briteDatabase.createQuery(tableGit).mapToList(
          (row) => RepoInfo.fromDatabase(row),
        );
  }

  Future<RepoInfo> gitDetails(int id) async {
    final _briteDatabase = await dbHelper.getDatabase;
    List q = await _briteDatabase.query(tableGit, where: 'ID = $id');
    print('rrrrrr ${q.runtimeType}');
    Map<String, dynamic> data = q.first;
    return RepoInfo.fromDatabase(data);
  }

  Future<void> deleteSelected(List list) async {
    final _briteDatabase = await dbHelper.getDatabase;
    final batch = _briteDatabase.batch();
    for (int item in list) {
      batch.delete(tableGit, where: 'ID = $item');
    }
    await batch.commit();
  }
}
