import 'package:geolocator/geolocator.dart';

class LocationClass {
  double longitude;
  double latitude;

  Future<void> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
