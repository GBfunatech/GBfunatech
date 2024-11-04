// Import the `path` package to handle file system paths.
import 'package:path/path.dart';
// Import the `sqflite` package to work with SQLite databases in Flutter.
import "package:sqflite/sqflite.dart";

// Define a class `DatabaseHelper` to manage database operations.
class DatabaseHelper {
  // Create a singleton instance of `DatabaseHelper`.
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Define a factory constructor to return the singleton instance.
  factory DatabaseHelper() {
    return _instance;
  }

  // Private internal constructor used to create the singleton instance.
  DatabaseHelper._internal();

  // A static reference to the database.
  static Database? _database;

  // A getter to return the database, initializing it if necessary.
  Future<Database> get database async {
    // If the database is already initialized, return it.
    if (_database != null) return _database!;

    // Initialize the database and return it.
    _database = await _initDatabase();
    return _database!;
  }

  // Private method to initialize the database.
  Future<Database> _initDatabase() async {
    // Define the path to store the database.
    String path = join(await getDatabasesPath(), 'vehicles.db');
    // Open the database at the specified path, with version 1 and call `_onCreate` if it's created.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Private method that runs when the database is created, defining the table structure.
  Future _onCreate(Database db, int version) async {
    // SQL command to create the 'vehicles' table with various columns for vehicle data.
    await db.execute('''
      CREATE TABLE vehicles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,  // Auto-increment primary key
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
        isActive INTEGER,  // 1 for active, 0 for inactive
        notes TEXT
      )
    ''');
  }

  // Method to insert a new vehicle into the database. Takes a map of vehicle data.
  Future<int> insertVehicle(Map<String, dynamic> vehicle) async {
    // Obtain a reference to the database.
    Database db = await database;
    // Insert the vehicle data into the 'vehicles' table and return the result.
    return await db.insert('vehicles', vehicle);
  }

  // Method to retrieve all vehicles from the database.
  Future<List<Map<String, dynamic>>> getVehicles() async {
    // Obtain a reference to the database.
    Database db = await database;
    // Query the 'vehicles' table and return the list of vehicle records.
    return await db.query('vehicles');
  }

  // Method to update an existing vehicle in the database.
  Future<int> updateVehicle(Map<String, dynamic> vehicle, int id) async {
    // Obtain a reference to the database.
    Database db = await database;
    // Update the vehicle record in the 'vehicles' table where the id matches.
    return await db.update(
      'vehicles',
      vehicle,
      where: 'id = ?',  // Condition to match the vehicle's id.
      whereArgs: [id],  // Pass the id as an argument to prevent SQL injection.
    );
  }

  // Method to delete a vehicle from the database by id.
  Future<int> deleteVehicle(int id) async {
    // Obtain a reference to the database.
    Database db = await database;
    // Delete the vehicle record from the 'vehicles' table where the id matches.
    return await db.delete(
      'vehicles',
      where: 'id = ?',  // Condition to match the vehicle's id.
      whereArgs: [id],  // Pass the id as an argument to prevent SQL injection.
    );
  }
}
