import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'LocationService.dart';
import 'add_data.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {

  Completer<GoogleMapController> _controller = Completer();

  static  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(32.5712103, 35.8512719),
    zoom: 14.4746,
  );

  LatLng currentLocation = _initialCameraPosition.target;

  BitmapDescriptor? _locationIcon;

  Set<Marker> _markers = {};

  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,

      appBar: AppBar(
      title: Text("اختار الموقع "),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            mapType: MapType.normal,
            onMapCreated: (controller) async {
              String style = await DefaultAssetBundle.of(context)
                  .loadString('assets/map_style.json');
              //customize your map style at: https://mapstyle.withgoogle.com/
              controller.setMapStyle(style);
              _controller.complete(controller);
            },
            onCameraMove:(CameraPosition newPos){
              setState(() {
                currentLocation=newPos.target;
              });
            },
            markers: _markers,
            polylines: _polylines,
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/images/location_icon.png'),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () => _setMarker(currentLocation),
            child: Icon(Icons.location_on),
          ),

        ],
      ),
      bottomNavigationBar: Container(
        height: 20,
        alignment: Alignment.center,
        child: Text(
            "lat: ${currentLocation.latitude}, long: ${currentLocation.longitude}"),
      ),
    );
  }

  Future<void> _getMyLocation() async {
    Position? _myLocation = (await LocationService().determinePosition()) ;
    print(_myLocation);
    _animateCamera(LatLng(_myLocation.latitude!, _myLocation.longitude!));
  }

  void _setMyLocation(){
    //_getMyLocation();
   // _initialCameraPosition;
    print(
        "animating camera to (lat: ${_initialCameraPosition}, long: ${_initialCameraPosition}");
    setState(() {

    });

  }

  Future<void> _animateCamera(LatLng _location) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
      target: _location,
      zoom: 13.00,
    );
    print(
        "animating camera to (lat: ${_location.latitude}, long: ${_location.longitude}");
    _initialCameraPosition=_cameraPosition;

  }

  void _setMarker(LatLng _location) {
    Marker newMarker = Marker(
      markerId: MarkerId(_location.toString()),
      icon: BitmapDescriptor.defaultMarker,
      // icon: _locationIcon,
      position: _location,
      infoWindow: InfoWindow(
          title: "Title",
          snippet: "${currentLocation.latitude}, ${currentLocation.longitude}"),
    );
    _markers.add(newMarker);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddData(longitude: currentLocation.longitude,latitude: currentLocation.latitude);

    }));
    // setState(() {});
  }
}
