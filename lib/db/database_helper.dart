import 'package:sqflite/sqflite.dart' as sql;

String _tableName = 'contacts';

class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'contacts.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user TEXT,
        phone TEXT,
        checkIn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

// id: the id of a item
// title, description: name and description of  activity
// created_at: the time that the item was created. It will be automatically handled by SQLite
  // Create new item

  static Future<int> createItem(
      String? user, String? phone, String? checkIn) async {
    final db = await DatabaseHelper.db();

    final data = {'user': user, 'phone': phone, 'checkIn': checkIn};
    final id = await db.insert(_tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;

    // When a UNIQUE constraint violation occurs,
    // the pre-existing rows that are causing the constraint violation
    // are removed prior to inserting or updating the current row.
    // Thus the insert or update always occurs.
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query(_tableName, orderBy: "id");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  /* static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String user, String phone) async {
    final db = await DatabaseHelper.db();

    final data = {
      'user': user,
      'phone': phone,
      'checkIn': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  } */
}
