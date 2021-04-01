import 'package:geolocator/geolocator.dart';

class GeoLocatorService{

  Future<Position> getLocation() async {
    var geolocator = Geolocator();
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}