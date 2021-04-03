import 'package:parking_locator/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerService {

  List<Marker> getMarkers(List<Place> places){
    var markers = List<Marker>();

    places.forEach((place){
      Marker marker = Marker( 
        markerId: MarkerId(place.address),
        draggable: false,
        icon: place.icon,
        // icon:BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: place.address),
        position: LatLng(place.lat, place.long)
      );

      markers.add(marker);
    });

  return markers;
  }
}
