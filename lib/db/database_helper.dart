import 'package:flutter_vimigo/model/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//initiate database
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
    const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT";
    const timeType = "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP";

    await db.execute(
        """CREATE TABLE $tableName (${ContactFields.id} $idType, ${ContactFields.user} $textType, ${ContactFields.phone} $textType, ${ContactFields.checkIn} $timeType)""");
  }

  // create new user
  Future<Contact> createContact(Contact contact) async {
    final db = await instance.database;

    final id = await db.insert(tableName, contact.toJson());
    return contact.copy(id: id);
  }

  // get all user contact by ID
  Future<List<Contact>> getContact() async {
    final db = await instance.database;

    const orderBy = '${ContactFields.id} ASC';

    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((json) => Contact.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
