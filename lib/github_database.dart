import 'package:github_flutter_app/github_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class GitHubDatabase{
  Database? _database;

  Future<Database> get db async {
    final dbpath = await getDatabasesPath();
    const dbname = 'github.db';
    final path = join(dbpath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

  return _database!;
  }


  Future<void> _createDB(Database db, int version) async{
    await db.execute('''
    CREATE TABLE git(
    offline_id INTEGER PRIMARY KEY AUTOINCREMENT,
    id INTEGER,
    name TEXT,
    gitUrl TEXT,
    owner TEXT,
    avatarUrl 
    )
    ''');
  }

  Future<void> insertGitHub(RepoInfo repoInfo) async {
    final db = await _database;

    await db?.insert(
      'git',
      repoInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> deleteGitHub(RepoInfo repoinfo) async{
    final db = await _database;

    await db?.delete(
      'git',
      where: 'id == ?',
      whereArgs: [repoinfo.id]
    );
  }

  Future<List<RepoInfo>> getRepoInfo() async {
    final db = await _database;

    List<Map<String, dynamic>> items = await db!.query(
      'git',
      orderBy: 'id DESC'
    );
    return List.generate(
      items.length,
        (i) => RepoInfo(
          id: items[i]['id'],
          name: items[i]['name'],
          avatarUrl: items[i]['avatarUrl'],
          gitUrl: items[i]['gitUrl'],
          owner: items[i]['owner'],
        )
    );
  }
}