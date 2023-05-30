import 'package:assignment/TasksModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TasksDb {
  static final TasksDb instance = TasksDb._init();
  TasksDb._init();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
create table tasks ( 
  id integer primary key autoincrement, 
  task text not null)
''');
    await db.execute('''
  create table users ( 
  id integer primary key autoincrement, 
  email text not null,
  name text not null,
  password text not null
  )
''');
  }

  Future<bool> insert({required String table, data}) async {
    try {
      final db = await instance.database;
      await db.insert(table, data);
      print('task added');
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<dynamic>> getAll(String table) async {
    final db = await instance.database;

    final result = await db.query(table);

    return result;
  }

  Future<bool> delete(int id, String tableName) async {
    try {
      final db = await instance.database;
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      return false;
      print(e.toString());
    }
  }

  Future<bool> update(String table, TaskModel task, String update) async {
    try {
      final db = await instance.database;
      db.update(
        table,
        {'task': update},
        where: 'id = ?',
        whereArgs: [task.id],
      );
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> insertUser(data) async {
    try {
      final db = await instance.database;
      await db.insert('users', data);
      print('User added');
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final db = await instance.database;
      List res = await db.query('users',
          where: 'email = ? AND password = ?', whereArgs: [email, password]);
      if (res.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
