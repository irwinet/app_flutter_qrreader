import 'dart:io';

import 'package:app_flutter_qrreader/src/models/scan_model.dart';
export 'package:app_flutter_qrreader/src/models/scan_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider{
  static Database _database;
  static final DBProvider	db = DBProvider._();

  DBProvider._();

  Future<Database>get database async {
    if(_database!=null) return _database;
    _database = await initDB();

    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,'ScansDB.db'); 

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        await db.execute(
          'CREATE TABLE Scans('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      },
    );
  }

  //CRUD Scans
  newScanRow(ScanModel model) async{
    final db = await database;

    final res = await db.rawInsert(
      "INSERT INTO Scans (id,type,value) "
      "VALUES ( ${model.id}, '${model.type}','${model.value}' )"
    );

    return res;
  }

  newScan(ScanModel model) async{
    final db = await database;

    final res = await db.insert('Scans', model.toJson());

    return res;
  }

  Future<ScanModel>getScanById(int id) async{
    final db = await database;
    
    final res = await db.query('Scans', where: 'id=?',whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first):null;
  }

  Future<List<ScanModel>> getAllScans() async{
    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList():[];

    return list;
  }

  Future<List<ScanModel>> getAllScansByType(String type) async{
    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Scans WHERE type='$type'");

    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList():[];

    return list;
  }

  Future<int> updateScan(ScanModel model) async{
    final db = await database;
    final res = await db.update('Scans', model.toJson(), where: 'id=?',whereArgs: [model.id]);
    return res;
  }

  Future<int> deleteScan(int id) async{
    final db = await database;
    final res = await db.delete('Scans', where: 'id=?',whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async{
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
  //End CRUD Scans

}