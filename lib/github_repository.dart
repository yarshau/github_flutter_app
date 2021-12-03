import 'package:github_flutter_app/github_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:github_flutter_app/github_model.dart';
import 'github_model.dart';

class GitHubRepository {
  GitHubRepository();

  static const String tablename = 'git';
  static final DatabaseProvider dbHelper = DatabaseProvider();

  Future<void> insert(List<RepoInfo> items) async {

    print('inside insert method');
    final db = await dbHelper.getDatabase;
    final batch = db.batch();
    for (var item in items) {
      batch.insert(tablename, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<void> clear() async {
    final db = await dbHelper.getDatabase;
    db.rawDelete('DELETE FROM git');
  }
//
//  Future<List<RepoInfo>> getRepoInfo() async {
//    final db = await database;
//
//    List<Map<String, dynamic>> items =
//        await db!.query('git', orderBy: 'id DESC');
//    return List.generate(
//        items.length,
//        (i) => RepoInfo(
//              id: items[i]['id'],
//              name: items[i]['name'],
//              avatarUrl: items[i]['avatarUrl'],
//              gitUrl: items[i]['gitUrl'],
//              owner: items[i]['owner'],
//            ));
//  }
}
