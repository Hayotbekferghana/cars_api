import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:task_project/db/cached_company.dart';


class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();
  static Database? _database;
  factory LocalDatabase() {
    return getInstance;
  }
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("todos.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const textType = "TEXT";
    const intType = "INTEGER";
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType = "BOOLEAN NOT NULL";
    await db.execute("""
    CREATE TABLE $tableName (
    ${CachedCompanyFields.id} $idType,
    ${CachedCompanyFields.logo} $textType,
    ${CachedCompanyFields.averagePrice} $intType,
    ${CachedCompanyFields.carModel} $textType,
    ${CachedCompanyFields.establishedYear} $intType,
    ${CachedCompanyFields.isFavorite} $boolType
    
    )""");
    await db.close();
  }
  LocalDatabase._init();
  //-------------------------------------------Cached Company Table------------------------------------
  static Future<CachedCompany> insertCachedTodo(CachedCompany cachedCompany) async {
    final db = await getInstance.database;
    final id = await db.insert(tableName, cachedCompany.toJson());
    return cachedCompany.copyWith(id: id);
  }

  static Future<List<CachedCompany>> getAllCachedCompanies() async {
    final db = await getInstance.database;
    const orderBy = CachedCompanyFields.carModel;
    final result = await db.query(tableName, orderBy: orderBy);
    return result.map((json) => CachedCompany.fromJson(json)).toList();
  }

  static Future<int> deleteAllCachedCompanies(CachedCompany cachedCompany) async {
    final db = await getInstance.database;
    return db.delete(tableName);
  }
  static Future<int> deleteCachedCompanyById(int id) async {
    final db = await getInstance.database;
    var t = await db
        .delete(tableName, where: "${CachedCompanyFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }
}
