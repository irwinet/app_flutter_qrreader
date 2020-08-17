import 'package:app_flutter_qrreader/src/models/scan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatefulWidget {
  //const MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = new MapController();

  String typeMap = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createButtonFloating(context),
    );
  }

  Widget _createButtonFloating(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){

        if(typeMap=='streets'){
          typeMap='dark';
        }
        else if (typeMap=='dark'){
          typeMap = 'light';
        }
        else if (typeMap=='light'){
          typeMap = 'outdoors';
        }
        else if (typeMap=='outdoors'){
          typeMap = 'satellite';
        }
        else{
          typeMap = 'streets';
        }

        setState((){});

      },
    );
  }

  Widget _createFlutterMap(ScanModel model){
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: model.getLatLng(),
        zoom: 15
      ),
      layers: [
        _createMap(),
        _createMark(model),
      ],
    );
  }

  _createMap(){
    return TileLayerOptions(
      urlTemplate: 'https://api.tiles.mapbox.com/v4/'
        '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken':'pk.eyJ1Ijoiam9yZ2VncmVnb3J5IiwiYSI6ImNrODk5aXE5cjA0c2wzZ3BjcTA0NGs3YjcifQ.H9LcQyP_-G9sxhaT5YbVow',
        'id': 'mapbox.$typeMap'
        // streets, dark, light, outdoors, satellite
      }
    );
  }

  _createMark(ScanModel model){
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: model.getLatLng(),
          builder: (context)=> Container(
            child: Icon(
              Icons.location_on,
              size: 70.0, 
              color: Theme.of(context).primaryColor,
            ),
          )
        ),
      ]
    );
  }
}