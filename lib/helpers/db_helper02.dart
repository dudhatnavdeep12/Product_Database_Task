import 'package:path/path.dart';
import 'package:product_database_task/models/product_models.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper2 {
  DBHelper2._();
  String table = "Products";
  var database;
  initDB() async {
    if (database == null) {
      database = openDatabase(join(await getDatabasesPath(), "product_08.db"),
          version: 1, onCreate: (db, version) {
        String sql =
            "CREATE TABLE $table(id INTEGER, name TEXT,type TEXT,quantity INTEGER,PRIMARY KEY('id' AUTOINCREMENT))";
        db.execute(sql);
      });
    }
    return database;
  }

  addData({required Product products}) async {
    var db = await initDB();
    String sql =
        "INSERT INTO Products(name,quantity,type)VALUES('${products.name}',${products.quantity},'${products.type}')";
    return await db.rawInsert(sql);
  }

  Future<int> deleteRecord(int? id) async {
    var db = await initDB();

    String query = "DELETE FROM $table WHERE id=$id";
    int deletedId = await db.rawDelete(query);
    return deletedId;
  }

  Future<List<Product>> allProducts() async {
    var db = await initDB();
    String sql = "SELECT * FROM $table ";
    List<Map<String, dynamic>> res = await db.rawQuery(sql);
    List<Product> response =
        res.map((record) => Product.fromMap(record)).toList();
    print(response);
    return response;
  }
}

DBHelper2 dbHelper2 = DBHelper2._();
