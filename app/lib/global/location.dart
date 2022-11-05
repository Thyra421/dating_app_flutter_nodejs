import 'package:location/location.dart' as loc;

class Location {
  static loc.Location location = loc.Location();

  static Future<bool> _isEnabled() async {
    bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      print("location service not enabled");
      print("enabling location service");
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("failed enabling location service");
        return false;
      }
    }
    print("location service enabled");
    return true;
  }

  static Future<bool> _hasPermission() async {
    loc.PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted == loc.PermissionStatus.denied) {
      print("permission to access location denied");
      print("enabling location permission");
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        print("failed enabling location permission");
        return false;
      }
    }
    print("location permission granted");
    return true;
  }

  static Future<loc.LocationData?> tryGetLocation() async {
    if (!await _isEnabled()) return null;
    if (!await _hasPermission()) return null;

    loc.LocationData locationData = await location.getLocation();
    print("location is $locationData");
    return locationData;
  }
}
