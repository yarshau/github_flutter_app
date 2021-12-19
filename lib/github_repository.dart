import 'dart:async';

import 'package:github_flutter_app/github_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class GitHubRepository {
//  StreamController<bool> isDatabaseInitialized = StreamController();

//  GitHubRepository() {
////    initDb();
//  }

//  Future<void> initDb() async {
//    final Database db = await dbHelper.getDatabase;
//    _briteDatabase = BriteDatabase(db);
//    isDatabaseInitialized.add(true);
//  }

  static const String tableGit = 'git';
  static final DatabaseProvider dbHelper = DatabaseProvider();

  Future<void> insert(List<RepoInfo> items) async {
    print('inside insert method');
    List<Map> existedId;
    final _briteDatabase = await dbHelper.getDatabase;
    final batch = _briteDatabase.batch();
    for (var item in items) {
      existedId =
          await _briteDatabase.query(tableGit, where: 'id = ${item.id}');
      if (existedId.isEmpty) {
        batch.insert(tableGit, item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    await batch.commit();
  }

//  Future<void> clear() async {
//    print('inside clear method');
//    final db = await dbHelper.getDatabase;
//    db.rawDelete('DELETE FROM $tableGit');
//  }

//  Future<bool> isNotEmpty() async {
//    final db = await dbHelper.getDatabase;
//    final List<Map<String, dynamic>> listMaps = await db.query(tableGit);
//    final bool isNotEmpty = listMaps.isNotEmpty;
//    return isNotEmpty;
//  }

  Future<Stream<List<RepoInfo>>> subscribeOnUpdates() async {
    final _briteDatabase = await dbHelper.getDatabase;

    return _briteDatabase.createQuery(tableGit).mapToList(
          (row) => RepoInfo.fromDatabase(row),
        );
  }

  Future<void> deleteSelected(List list) async {
    print('list to DELETE ${list.length}');
    final _briteDatabase = await dbHelper.getDatabase;
    final batch = _briteDatabase.batch();
    for (int item in list) {
      batch.delete(tableGit, where: 'ID = $item');
    }
    await batch.commit();
  }
}
