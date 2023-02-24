

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getLocation()  async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }




}