import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAgencyScreen extends StatelessWidget {
  final String agencyId;

  const ManageAgencyScreen({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tableau de bord")),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('agencies')
                .doc(agencyId)
                .collection('trips')
                .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          int totalTrips = snapshot.data!.docs.length;

          return Column(
            children: [
              Text(
                "Total des trajets: $totalTrips",
                style: const TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/manage_trips");
                },
                child: const Text("Gérer les trajets"),
              ),
            ],
          );
        },
      ),
    );
  }
}
