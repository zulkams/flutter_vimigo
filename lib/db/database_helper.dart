import 'package:flutter_vimigo/model/contact.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//table name
/* String _tableName = 'contacts';

class DatabaseHelper {
  // initiate database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'contacts.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // create table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user TEXT,
        phone TEXT,
        checkIn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  // create new user
  static Future<int> createItem(
      String? user, String? phone, String? checkIn) async {
    final db = await DatabaseHelper.db();

    final data = {'user': user, 'phone': phone, 'checkIn': checkIn};
    final id = await db.insert(_tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all contacts
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query(_tableName, orderBy: "id");
  }
}
 */

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final timeType = 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP';

    await db.execute(
        '''CREATE TABLE $tableName (${ContactFields.id} $idType, ${ContactFields.user} $textType, ${ContactFields.phone} $textType, ${ContactFields.checkIn} $timeType''');
  }

  Future<Contact> createItem(Contact contact) async {
    final db = await instance.database;

    final id = await db.insert(tableName, contact.toJson());
    return contact.copy(id: id);
  }

  Future<List<Contact>> getItems() async {
    final db = await instance.database;

    final orderBy = '${ContactFields.id} ASC';

    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((json) => Contact.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
