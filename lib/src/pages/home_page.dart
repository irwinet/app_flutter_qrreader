import 'dart:io';

import 'package:app_flutter_qrreader/src/bloc/scans_bloc.dart';
import 'package:app_flutter_qrreader/src/models/scan_model.dart';
import 'package:app_flutter_qrreader/src/pages/address_page.dart';
import 'package:app_flutter_qrreader/src/pages/maps_page.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter_qrreader/src/utils/utils.dart' as utils;

import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteScanAll,
          )
        ],
      ),
      body: Center(
        child: _callPage(currentIndex),
      ),
      bottomNavigationBar: _createButtomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _scanQR(BuildContext context) async{
    //print('Scan QR...');
    // https://www.appwillay.com/
    // geo:-12.1746682,-76.9639777
    
    //dynamic futureString = 'https://www.appwillay.com/';
    var futureString;
    
    try{
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString = e.toString();
    }

    if(futureString!=null){
      final scan = ScanModel(value: futureString.rawContent);
      scansBloc.addScan(scan);

      //final scan2 = ScanModel(value: 'geo:40.724233047051705,-74.00731459101564');
      //DBProvider.db.newScan(scan);
      //scansBloc.addScan(scan2);

      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750),(){
          utils.openURL(scan, context);
        });
      }
      else{
        utils.openURL(scan, context);
      }
    }

    /*try{
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString = e.toString();
    }

    print('Future String: $futureString'); 

    if(futureString!=null){
      print('Get Info');
    }*/


  }

  Widget _callPage(int currentPage){
    switch(currentPage){
      case 0 : return MapsPage();            
      case 1 : return AddressPage();

      default: return MapsPage();
    }
  }

  Widget _createButtomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Address')
        )
      ],
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
    );
  }
}