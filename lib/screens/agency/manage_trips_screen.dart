import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageTripsScreen extends StatefulWidget {
  final String agencyId;

  const ManageTripsScreen({super.key, required this.agencyId});

  @override
  _ManageTripsScreenState createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends State<ManageTripsScreen> {
  Future<void> _deleteTrip(String tripId) async {
    await FirebaseFirestore.instance
        .collection('agencies')
        .doc(widget.agencyId)
        .collection('trips')
        .doc(tripId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Trajet supprimé"),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _toggleTripVisibility(String tripId, bool currentStatus) async {
    await FirebaseFirestore.instance
        .collection('agencies')
        .doc(widget.agencyId)
        .collection('trips')
        .doc(tripId)
        .update({'isBlocked': !currentStatus});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentStatus ? "Trajet débloqué" : "Trajet bloqué"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des trajets")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('agencies')
                .doc(widget.agencyId)
                .collection('trips')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun trajet disponible."));
          }

          final trips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              var trip = trips[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    "${trip['departure_place']} ➝ ${trip['destination']}",
                  ),
                  subtitle: Text(
                    "Prix: ${trip['price']} FCFA - Places: ${trip['availableSeats']}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(trip.id, trip);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTrip(trip.id),
                      ),
                      IconButton(
                        icon: Icon(
                          trip['isBlocked']
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.orange,
                        ),
                        onPressed:
                            () => _toggleTripVisibility(
                              trip.id,
                              trip['isBlocked'],
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(String tripId, DocumentSnapshot tripData) {
    TextEditingController priceController = TextEditingController(
      text: tripData['price'].toString(),
    );
    TextEditingController seatsController = TextEditingController(
      text: tripData['availableSeats'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier le trajet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Prix"),
              ),
              TextField(
                controller: seatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nombre de places",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('agencies')
                    .doc(widget.agencyId)
                    .collection('trips')
                    .doc(tripId)
                    .update({
                      'price': int.parse(priceController.text),
                      'availableSeats': int.parse(seatsController.text),
                    });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Trajet mis à jour"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }
}
