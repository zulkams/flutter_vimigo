import 'package:sqflite/sqflite.dart' as sql;

//table name
String _tableName = 'contacts';

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
