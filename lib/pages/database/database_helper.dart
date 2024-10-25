import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'vehicles.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        manufacturer TEXT,
        model TEXT,
        licensePlate TEXT,
        year TEXT,
        tankType TEXT,
        fuelType TEXT,
        fuelCapacity TEXT,
        distanceUnit TEXT,
        chassisNumber TEXT,
        vin TEXT,
        isActive INTEGER,
        notes TEXT
      )
    ''');
  }

  Future<int> insertVehicle(Map<String, dynamic> vehicle) async {
    Database db = await database;
    return await db.insert('vehicles', vehicle);
  }

  Future<List<Map<String, dynamic>>> getVehicles() async {
    Database db = await database;
    return await db.query('vehicles');
  }

  Future<int> updateVehicle(Map<String, dynamic> vehicle, int id) async {
    Database db = await database;
    return await db.update(
      'vehicles',
      vehicle,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteVehicle(int id) async {
    Database db = await database;
    return await db.delete(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
