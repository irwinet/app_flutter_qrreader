import 'package:app_flutter_qrreader/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

openURL(ScanModel model, BuildContext context) async {

  if(model.type=='http'){
    if (await canLaunch(model.value)) {
      await launch(model.value);
    } else {
      throw 'Could not launch $model.value';
    }
  }
  else{
    //print('GEO...');
    Navigator.pushNamed(context, 'map', arguments: model);
  }
  
}