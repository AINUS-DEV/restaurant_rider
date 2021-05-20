import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  LocationProvider({@required this.sharedPreferences});

  Address _address = Address();

  Address get address => _address;
  Position _currentLocation = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  Position get currentLocation => _currentLocation;

  Future<Position> locateUser() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void getUserLocation() async {
    _currentLocation = await locateUser();
    final currentCoordinates = new Coordinates(_currentLocation.latitude, _currentLocation.longitude);
    var currentAddresses = await Geocoder.local.findAddressesFromCoordinates(currentCoordinates);
    _address = currentAddresses.first;
    notifyListeners();
  }
}
