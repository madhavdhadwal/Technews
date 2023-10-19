import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../repositories/news_repository.dart';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  //Instance variable coming from sqflite package
  //Creates connection with our sqlite database
  late Database db;

  NewsDbProvider() {
    init();
  }
 
  void init() async {
    //Returns reference to a folder on the device where we can persist data
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //Join path to our directory followed by a db name
    final path = join(documentsDirectory.path, 'items1.db');

    //openDatabaseFunction (provided by sqflite package) either:
    //1)Open a db that already exists at the given path
    //2)Or create a new db if it doesn not exist at this path
    db = await openDatabase(
      path,
      //Change in schema, update version as well
      version: 1,
      //Only called if db didn't exist and is being created now
      onCreate: (Database newDb, int version) {
        newDb.execute('''
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              title TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              descendants INTEGER
            )
        ''');
      },
    );
  }

  Future<List<int>> fetchTopIds() async {
    return [];
  }

  Future<ItemModel?> fetchItem(int id) async {
    print('inside db_provider. Fetching $id');
    final maps = await db.query(
      'Items',
      //Specifiy column name to pull out a specific column from the table
      //In a list e.g., ['id']
      columns: null,
      //where and whereArgs are used hand in hand
      //To avoid sql injection (sanitise the data)
      where: 'id=?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      print('db found the item');
      return ItemModel.fromDb(maps.first);
    }
    print('DB provider didn\'t find anything. returning null');
    return null;
  }

  //No need to add async and await as nothing is returned
  //to the screen
  Future<int> addItem(ItemModel item) {
    return db.insert(
      'Items',
      item.toMap(),
      //add conflictAlgorithm property to handle any problems
    );
  }

  Future<int> clear() async {
    return await db.delete('Items');
  }
}

//SQlite doesn't like if we  try to open up multiple connections to the
//exact same database.
final newsDbProvider = NewsDbProvider();
