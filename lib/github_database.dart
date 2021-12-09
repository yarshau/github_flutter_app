import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  DatabaseProvider();

  DatabaseProvider._privateEmptyConstructor();

  static final DatabaseProvider db =
      DatabaseProvider._privateEmptyConstructor();
  Database? database;

  Future<Database> get getDatabase async {
    final dbpath = await getDatabasesPath();
    const dbname = 'github.db';
    final path = join(dbpath, dbname);

    database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE git(
    id INTEGER,
    name TEXT,
    gitUrl TEXT,
    avatarUrl TEXT
    )
    ''');
  }
}
