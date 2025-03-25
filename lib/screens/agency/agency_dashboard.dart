import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manage_trips_screen.dart';
import 'add_trip_screen.dart';
import 'agency_stats_screen.dart';
import 'manage_buses_screen.dart';

class AgencyDashboardScreen extends StatelessWidget {
  final String agencyId;

  const AgencyDashboardScreen({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de Bord"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Bienvenue dans votre tableau de bord",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Statistiques
            FutureBuilder<QuerySnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('agencies')
                      .doc(agencyId)
                      .collection('trips')
                      .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                int totalTrips = snapshot.data!.docs.length;
                double totalRevenue = snapshot.data!.docs.fold(
                  0,
                  (sum, doc) => sum + (doc['price'] * doc['availableSeats']),
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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

            const SizedBox(height: 20),

            // Options sous forme de grille
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildGridButton(
                    context,
                    "Ajouter un trajet",
                    Icons.add,
                    Colors.orange,
                    AddTripScreen(agencyId: agencyId),
                  ),
                  _buildGridButton(
                    context,
                    "Gérer les trajets",
                    Icons.list,
                    Colors.purple,
                    ManageTripsScreen(agencyId: agencyId),
                  ),
                  _buildGridButton(
                    context,
                    "Statistiques",
                    Icons.bar_chart,
                    Colors.red,
                    AgencyStatsScreen(agencyId: agencyId),
                  ),
                  _buildGridButton(
                    context,
                    "Gérer les bus",
                    Icons.directions_bus,
                    Colors.teal,
                    ManageBusesScreen(agencyId: agencyId),
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildGridButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: color.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
