import 'package:sauce_ticket/models/Tokens.dart';
import 'package:sauce_ticket/screens/SavedUserTokens.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TicketDataBase {
  String path;
  Database db;
  String tableTokens = "Tokens";
  String columnAccess = "access";
  String columnRefresh = "refresh";

  TicketDataBase._();

  static final TicketDataBase ticketDb= TicketDataBase._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await init();
    return _database;
  }


  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'ticket.db');
    print("Entered path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE $tableTokens ( $columnAccess TEXT, $columnRefresh TEXT);');
          print('New table created at $path');
        });
  }


  Future<void> insert(Tokens tokens) async {
    final db = await database;
    await db.insert(tableTokens, tokens.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,);
    print("Successfully Saved to Db");
  }

  Future<void> delete() async {
    final db = await database;
    return await db.rawQuery('DELETE FROM $tableTokens');
  }

  Future<SavedUserTokens> getToken() async {
    final db = await database;
    List<Map> maps = await db.rawQuery('SELECT * FROM $tableTokens');
    if (maps.length > 0) {
      return SavedUserTokens.fromJson(maps.first);
    }
    return null;
  }

}