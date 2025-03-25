import 'dart:math'; // Import pour générer des valeurs aléatoires
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Propriété pour accéder à la collection 'agencies'
  CollectionReference get agencies => _db.collection('agencies');

  // Méthode pour générer un mot de passe sécurisé
  String generateSecurePassword({int length = 12}) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#\$%^&*';
    final Random random = Random.secure();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  // Ajouter une agence avec un rôle par défaut et retourner le mot de passe généré
  Future<String> addAgency({
    required String name,
    required String email,
    required String phone,
    required String city,
    required String address,
    String role = "admin_agency", // Rôle par défaut
  }) async {
    try {
      // Générer un mot de passe sécurisé
      String generatedPassword = generateSecurePassword();

      // Création de l'utilisateur dans Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email,
            password: generatedPassword, // Utiliser le mot de passe généré
          );

      String agencyId = userCredential.user!.uid; // Récupérer l'ID utilisateur

      // Enregistrer l'agence dans Firestore
      await _db.collection('agencies').doc(agencyId).set({
        'id': agencyId,
        'name': name,
        'email': email,
        'phone': phone,
        'city': city,
        'address': address,
        'role': role,
        'createdAt': Timestamp.now(),
      });

      // Enregistrer l'utilisateur avec le rôle "admin_agency"
      await _db.collection('users').doc(agencyId).set({
        'id': agencyId,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'createdAt': Timestamp.now(),
      });

      print("✅ Agence et utilisateur ajoutés avec succès !");
      print("Mot de passe généré : $generatedPassword");

      // Retourner le mot de passe généré
      return generatedPassword;
    } catch (e) {
      throw Exception("Erreur lors de l'ajout de l'agence : $e");
    }
  }

  // Supprimer une agence
  Future<void> deleteAgency(String agencyId) async {
    try {
      // Supprimer l'agence de Firestore
      await _db.collection('agencies').doc(agencyId).delete();

      // Supprimer l'utilisateur de Firestore
      await _db.collection('users').doc(agencyId).delete();

      print("✅ Agence et utilisateur supprimés !");
    } catch (e) {
      throw Exception("Erreur lors de la suppression de l'agence : $e");
    }
  }

  // Mettre à jour une agence
  Future<void> updateAgency({
    required String agencyId,
    required String name,
    required String email,
    required String phone,
    required String city,
    required String address,
  }) async {
    try {
      // Mettre à jour les informations de l'agence dans Firestore
      await _db.collection('agencies').doc(agencyId).update({
        'name': name,
        'email': email,
        'phone': phone,
        'city': city,
        'address': address,
      });

      // Mettre à jour les informations de l'utilisateur dans Firestore
      await _db.collection('users').doc(agencyId).update({
        'name': name,
        'email': email,
        'phone': phone,
      });

      print("✅ Agence et utilisateur mis à jour !");
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour de l'agence : $e");
    }
  }
}
