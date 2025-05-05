import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/location.dart';

class LocationService {
  final CollectionReference _locations =
  FirebaseFirestore.instance.collection('locations');

  //Them
  Future<void> addLocation(Location location) async {
    print("Đang thêm location: ${location.toJson()}");
    await _locations.doc(location.id).set(location.toJson());
  }

  //Sua
  Future<void> updateLocation(Location location) async {
    await _locations.doc(location.id).update(location.toJson());
  }
  //Xoa
  Future<void> deleteLocation(String id) async {
    await _locations.doc(id).delete();
  }
  //Lay toan bo
  Stream<List<Location>> getAllLocations() {
    return _locations.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Location.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }
}
