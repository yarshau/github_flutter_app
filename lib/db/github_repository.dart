import 'dart:async';
import 'package:github_flutter_app/db/github_database.dart';
import 'package:github_flutter_app/api/github_model.dart';
import '../api/github_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class GitHubRepository {
  static const String _tableGit = 'git';
  static final DatabaseProvider _dbHelper = DatabaseProvider();

  Future<void> insert(List<RepoInfo> items) async {
    print('inside insert method');
    List<Map> _existedId;
    final _briteDatabase = await _dbHelper.getDatabase;
    final batch = _briteDatabase.batch();
    for (var item in items) {
      _existedId =
          await _briteDatabase.query(_tableGit, where: 'id = ${item.id}');
      if (_existedId.isEmpty) {
        batch.insert(_tableGit, item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    await batch.commit();
  }

  Future<Stream<List<RepoInfo>>> subscribeOnUpdates() async {
    final _briteDatabase = await _dbHelper.getDatabase;

    return _briteDatabase.createQuery(_tableGit).mapToList(
          (row) => RepoInfo.fromDatabase(row),
        );
  }

  Future<RepoInfo> gitDetails(int id) async {
    final _briteDatabase = await _dbHelper.getDatabase;
    List<Map<String, Object?>> q = await _briteDatabase.query(_tableGit, where: 'ID = $id');
    Map<String, dynamic> data = q.first;
    return RepoInfo.fromDatabase(data);
  }

  Future<void> deleteSelected(List list) async {
    final _briteDatabase = await _dbHelper.getDatabase;
    final batch = _briteDatabase.batch();
    for (int item in list) {
      batch.delete(_tableGit, where: 'ID = $item');
    }
    await batch.commit();
  }
}
