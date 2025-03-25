import 'package:cloud_firestore/cloud_firestore.dart';

class TripService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Ajouter un trajet
  Future<void> addTrip(
    String agencyId,
    String branchId,
    Map<String, dynamic> tripData,
  ) async {
    await _firestore
        .collection('agencies')
        .doc(agencyId)
        .collection('branches')
        .doc(branchId)
        .collection('trips')
        .add(tripData);
  }

  /// 🔹 Récupérer les trajets d'une agence
  Stream<QuerySnapshot> getTrips(String agencyId, String branchId) {
    return _firestore
        .collection('agencies')
        .doc(agencyId)
        .collection('branches')
        .doc(branchId)
        .collection('trips')
        .snapshots();
  }
}
