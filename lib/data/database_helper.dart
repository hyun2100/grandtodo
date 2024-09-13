import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "todo_database.db";
  static const _databaseVersion = 3;  // 버전을 3으로 올립니다.

  static const table = 'todos';

  static const columnId = 'id';
  static const columnDate = 'date';
  static const columnTime = 'time';
  static const columnTitle = 'title';
  static const columnContent = 'content';
  static const columnIsCompleted = 'isCompleted';
  static const columnRepeatType = 'repeatType';
  static const columnRepeatWeekdays = 'repeatWeekdays';
  static const columnRepeatMonthDay = 'repeatMonthDay';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT NOT NULL,
        $columnTime TEXT NOT NULL,
        $columnTitle TEXT NOT NULL,
        $columnContent TEXT NOT NULL,
        $columnIsCompleted INTEGER NOT NULL DEFAULT 0,
        $columnRepeatType TEXT NOT NULL DEFAULT '반복 없음',
        $columnRepeatWeekdays TEXT,
        $columnRepeatMonthDay INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $table ADD COLUMN $columnIsCompleted INTEGER NOT NULL DEFAULT 0');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE $table ADD COLUMN $columnRepeatType TEXT NOT NULL DEFAULT "반복 없음"');
      await db.execute('ALTER TABLE $table ADD COLUMN $columnRepeatWeekdays TEXT');
      await db.execute('ALTER TABLE $table ADD COLUMN $columnRepeatMonthDay INTEGER');
    }
  }

  Future<int> insertTodo(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    Database db = await database;
    return await db.query(table, orderBy: '$columnDate ASC, $columnTime ASC');
  }

  Future<int> updateTodo(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteTodo(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}