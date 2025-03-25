import 'package:cloud_firestore/cloud_firestore.dart';

class AgencyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter une agence
  Future<void> addAgency({
    required String name,
    required String email,
    required String phone,
    required String ownerId,
  }) async {
    try {
      DocumentReference agencyRef = await _db.collection('agencies').add({
        'name': name,
        'email': email,
        'phone': phone,
        'ownerId': ownerId,
      });

      print("✅ Agence ajoutée avec succès : ${agencyRef.id}");
    } catch (e) {
      print("❌ Erreur lors de l'ajout de l'agence : $e");
    }
  }

  // Récupérer toutes les agences
  Stream<QuerySnapshot> getAgencies() {
    return _db.collection('agencies').snapshots();
  }

  // Ajouter une succursale (branch) à une agence
  Future<void> addBranch({
    required String agencyId,
    required String city,
    required String address,
    required String managerId,
  }) async {
    try {
      await _db.collection('agencies').doc(agencyId).collection('branches').add(
        {'city': city, 'address': address, 'managerId': managerId},
      );

      print("✅ Succursale ajoutée avec succès");
    } catch (e) {
      print("❌ Erreur lors de l'ajout de la succursale : $e");
    }
  }

  // Récupérer toutes les succursales d'une agence
  Stream<QuerySnapshot> getBranches(String agencyId) {
    return _db
        .collection('agencies')
        .doc(agencyId)
        .collection('branches')
        .snapshots();
  }

  // Ajouter un trajet
  Future<void> addTrip({
    required String agencyId,
    required String branchId,
    required String departurePlace,
    required String destination,
    required String date,
    required String time,
    required int price,
    required int availableSeats,
    required String busType,
  }) async {
    try {
      await _db
          .collection('agencies')
          .doc(agencyId)
          .collection('branches')
          .doc(branchId)
          .collection('trips')
          .add({
            'departure_place': departurePlace,
            'destination': destination,
            'date': date,
            'time': time,
            'price': price,
            'availableSeats': availableSeats,
            'busType': busType,
          });

      print("✅ Trajet ajouté avec succès");
    } catch (e) {
      print("❌ Erreur lors de l'ajout du trajet : $e");
    }
  }

  // Récupérer tous les trajets d'une succursale
  Stream<QuerySnapshot> getTrips(String agencyId, String branchId) {
    return _db
        .collection('agencies')
        .doc(agencyId)
        .collection('branches')
        .doc(branchId)
        .collection('trips')
        .snapshots();
  }
}
