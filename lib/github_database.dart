import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlbrite/sqlbrite.dart';

class DatabaseProvider {
  DatabaseProvider();

  DatabaseProvider._privateEmptyConstructor();

  static final DatabaseProvider db =
      DatabaseProvider._privateEmptyConstructor();
  Database? database;
  late BriteDatabase _briteDatabase;

  Future<BriteDatabase> get getDatabase async {
    if (database == null) {
      final dbpath = await getDatabasesPath();
      const dbname = 'github.db';
      final path = join(dbpath, dbname);
      print('db path is: $path');
      database = await openDatabase(path, version: 1, onCreate: _createDB);
      _briteDatabase = BriteDatabase(database!);
    }
    return _briteDatabase;
  }

  Future<void> _createDB(Database db, int version) async {
    var streamDb = BriteDatabase(db);
    await streamDb.execute('''
    CREATE TABLE git(
    id INTEGER,
    name TEXT,
    gitUrl TEXT,
    avatarUrl BLOB,
    login TEXT,
    fullName TEXT,
    organizationsUrl TEXT,
    licenseName TEXT,
    language TEXT,
    description TEXT,
    url TEXT,
    createdDate TEXT,
    watchers INTEGER
    )
    ''');
  }
}
