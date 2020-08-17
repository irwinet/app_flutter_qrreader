import 'package:app_flutter_qrreader/src/bloc/scans_bloc.dart';
import 'package:app_flutter_qrreader/src/models/scan_model.dart';
import 'package:app_flutter_qrreader/src/utils/utils.dart' as utils;

import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  //const MapsPage({Key key}) : super(key: key);
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      //future: DBProvider.db.getAllScans(),
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }

        final scans = snapshot.data;

        if(scans.length==0){
          return Center(child: Text('Dont display data'),);
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i)=>Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction)=>scansBloc.deleteScan(scans[i].id),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
              title: Text(scans[i].value),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
              onTap: (){
                utils.openURL(scans[i], context);
              },
            ),            

          ),
        );

      },
    );
  }
}