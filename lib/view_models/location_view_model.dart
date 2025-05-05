import 'package:flutter/material.dart';
import '../models/location.dart';
import '../services/location_service.dart';

class LocationViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  List<Location> locations = [];

  void fetchLocations() {
    _locationService.getAllLocations().listen((data) {
      locations = data;
      notifyListeners();
    });
  }

  Future<void> addLocation(Location location) async {
    await _locationService.addLocation(location);
  }

  Future<void> updateLocation(Location location) async {
    await _locationService.updateLocation(location);
  }

  Future<void> deleteLocation(String id) async {
    await _locationService.deleteLocation(id);
  }
}
