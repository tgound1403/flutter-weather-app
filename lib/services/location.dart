import 'package:geolocator/geolocator.dart';
class Location {
  double latitude;
  double longitude;
  //update method from void to Future<void>
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}