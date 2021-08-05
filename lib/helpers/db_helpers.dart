import 'package:path/path.dart';
import 'package:product_database_task/models/attributes_models.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  String TABLE = "Attribute";
  var database;

  Future<Database> initDB() async {
    if (database == null) {
      database = openDatabase(
        join(await getDatabasesPath(), "product_db08.db"),
        version: 1,
        onCreate: (db, version) {
          String sql =
              "CREATE TABLE $TABLE(id INTEGER, attribute TEXT,PRIMARY KEY('id' AUTOINCREMENT))";
          return db.execute(sql);
        },
      );
      return database;
    }
    return database;
  }

  Future<int> insertAttributes({Attribute? s}) async {
    var db = await initDB();
    String sql = "INSERT INTO $TABLE(attribute)VALUES('${s!.attribute}')";
    return await db.rawInsert(sql);
  }

  Future<int> deleteRecord(int? id) async {
    var db = await initDB();

    String query = "DELETE FROM $TABLE WHERE id=$id";
    int deletedId = await db.rawDelete(query);
    return deletedId;
  }

  Future<List<Attribute>> getAllAttribute() async {
    var db = await initDB();
    String sql = "SELECT * FROM $TABLE";
    List<Map<String, dynamic>> res = await db.rawQuery(sql);
    List<Attribute> response =
        res.map((record) => Attribute.fromMap(record)).toList();
    return response;
  }
}

DBHelper dbhattribute = DBHelper._();
