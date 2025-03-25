import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBusesScreen extends StatelessWidget {
  final String agencyId;

  const ManageBusesScreen({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Bus")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('agencies')
                .doc(agencyId)
                .collection('buses')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var buses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              var bus = buses[index];
              return ListTile(
                title: Text("Bus ${bus['bus_number']}"),
                subtitle: Text("Capacité: ${bus['capacity']} places"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await bus.reference.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bus supprimé")),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logique pour ajouter un bus (à implémenter)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
