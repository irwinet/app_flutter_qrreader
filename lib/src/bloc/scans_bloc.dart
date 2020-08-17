import 'dart:async';

import 'package:app_flutter_qrreader/src/providers/db_provider.dart';

class ScansBloc{
  static final ScansBloc _singleton = new ScansBloc._internal();
  
  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //Get scans db
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;


  dispose(){
    _scansController?.close();
  }  

  getScans() async{    
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  addScan(ScanModel model) async{
    await DBProvider.db.newScan(model);
    getScans();
  }

  deleteScan(int id) async{
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteScanAll() async{
    await DBProvider.db.deleteAll();
    getScans();
    //_scansController.sink.add([]);
  }
}