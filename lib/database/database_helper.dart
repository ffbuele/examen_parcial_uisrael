import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  DatabaseHelper._internal();

  static DatabaseHelper get instance =>
      _instance ??= DatabaseHelper._internal();

  Database? _db;
  Database get db => _db!;

  static const int _dbVersion = 2;
  static const String _dbName = 'matriculas.db';

  Future<void> init() async {
    final path = join(await getDatabasesPath(), _dbName);

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        print('🧱 Creando base de datos v$version...');
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print(
          '🔄 Actualizando base de datos de v$oldVersion a v$newVersion...',
        );
        if (oldVersion < 2) {
          await _createTables(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // 🧍 Tabla Estudiantes
    await db.execute('''
      CREATE TABLE IF NOT EXISTS estudiantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        cedula TEXT UNIQUE,
        correo TEXT,
        telefono TEXT,
        carrera TEXT NOT NULL,
        semestre INTEGER NOT NULL CHECK (semestre BETWEEN 1 AND 10),
        estado TEXT DEFAULT 'Activo',
        fecha_registro TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    print('✅ Tabla estudiantes creada');

    // 🎓 Tabla Matrículas
    await db.execute('''
      CREATE TABLE IF NOT EXISTS matriculas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        estudiante_id INTEGER NOT NULL,
        periodo TEXT NOT NULL,
        semestre INTEGER NOT NULL CHECK (semestre BETWEEN 1 AND 10),
        paralelo TEXT NOT NULL,
        creditos INTEGER DEFAULT 0,
        observaciones TEXT,
        fecha_matricula TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id) ON DELETE CASCADE
      )
    ''');
    print('✅ Tabla matriculas creada');
  }
}

Future<void> resetDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'matriculas.db');

  await deleteDatabase(path);
  print('🗑️ Base de datos eliminada correctamente.');
}
