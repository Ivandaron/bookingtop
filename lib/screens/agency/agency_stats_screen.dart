import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgencyStatsScreen extends StatelessWidget {
  final String agencyId;

  const AgencyStatsScreen({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques de l'agence"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<QuerySnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('agencies')
                  .doc(agencyId)
                  .collection('trips')
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Aucune donnée disponible.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // Calcul des statistiques
            int totalTrips = snapshot.data!.docs.length;
            double totalRevenue = 0;

            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final price = data['price'] ?? 0;

              // Vérifiez que la valeur de price est un nombre
              if (price is num) {
                totalRevenue += price;
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Statistiques générales",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildStatCard(
                  "Total des trajets",
                  totalTrips.toString(),
                  Icons.directions_bus,
                  Colors.blue,
                ),
                _buildStatCard(
                  "Revenu estimé",
                  "${totalRevenue.toInt()} FCFA",
                  Icons.monetization_on,
                  Colors.green,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
