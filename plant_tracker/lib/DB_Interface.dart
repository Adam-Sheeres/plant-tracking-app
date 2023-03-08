import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//TO DO: https://pub.dev/packages/sqflite

class DatabaseHelper {
  static final _databases = ['plants.db', 'rooms.db', 'notes.db'];
  static final _databaseVersion = 1;

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database object
  static Database? plant_db;

  Future<Database> get plants async {
    if (plant_db != null) return plant_db!;

    // Lazily instantiate the database
    plant_db = await _initDatabase(_databases[0]); //init the plant db
    return plant_db!;
  }

  // Initialize database
  Future<Database> _initDatabase(String name) async {
    String path = join(await getDatabasesPath(), name);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: createPlantsTable);
  }

  // Create table
  Future<void> createPlantsTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants (
        id INTEGER PRIMARY KEY,
        plant_name TEXT,
        date_added DATETIME, 
        water_days INTEGER,
        last_watered DATETIME,
        water_volume INT, 
        light_level TEXT, 
        light_type TEXT, 
        imageUrl TEXT, 
        description TEXT, 
        isFavourite INTEGER, 
        note INTEGER, 
        room TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE rooms (
        id INTEGER PRIMARY KEY,
        name TEXT,
      )
      ''');
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        note TEXT,
        dateAdded DATETIME
      )
      ''');
  }

  // Insert data into table
  Future<int> insertNewPlant(Map<String, dynamic> row) async {
    Database db = await instance.plants;
    return await db.insert('plants', row);
  }

  Future<int> insertNewNote(Map<String, dynamic> row) async {
    Database db = await instance.plants;
    return await db.insert('notes', row);
  }

  Future<int> insertNewRoom(Map<String, dynamic> row) async {
    Database db = await instance.plants;
    return await db.insert('rooms', row);
  }

  // Retrieve all data from table
  Future<List<Map<String, dynamic>>> getAllPlants() async {
    Database db = await instance.plants;
    return await db.query('plants');
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    Database db = await instance.plants;
    return await db.query('notes');
  }

  Future<List<Map<String, dynamic>>> getAllRooms() async {
    Database db = await instance.plants;
    return await db.query('rooms');
  }

  // Update data in table
  //for example, would pass in ("plants", "name = ?", name: silver, "monstera")

  //the above parameters would update plants whose name is monstera, and
  //set their name to be 'silver'. The 'row' is a MAP which will have column
  //names as the key and the value as the value.

  Future<int> updateData(String tableName, String whereCondition,
      Map<String, dynamic> row, List<String> whereArgs) async {
    Database db = await instance.plants;

    return await db.update(tableName, row,
        where: whereCondition, whereArgs: whereArgs);
  }

  //for instance, would pass in ("plants", "name = ?", ["room"], ["Monstera"])
  Future<List<Map<String, dynamic>>> selectPlant(
      String tableName, //name of the table, so plants, rooms, or notes
      String whereCondition, //where condition, values should be ?
      List<String> columns, //name of the columns -> See above for col names
      List<String> whereArgs) async {
    //where args should be a list of strings
    Database db = await instance.plants;
    return await db.query(tableName,
        columns: columns, where: whereCondition, whereArgs: whereArgs);
  }

  // Delete data from table
  Future<int> deleteData(int id) async {
    Database db = await instance.plants;
    return await db.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }
}
