import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'operaciones.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Categoria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT NOT NULL,
        color TEXT,
        icono TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE TipoOperacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Operacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monto REAL NOT NULL,
        fecha TEXT NOT NULL,
        categoria INTEGER NOT NULL,
        tipo_operacion INTEGER NOT NULL,
        FOREIGN KEY (categoria) REFERENCES Categoria (id),
        FOREIGN KEY (tipo_operacion) REFERENCES TipoOperacion (id)
      )
    ''');
  }
}
