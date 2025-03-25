import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/trip_service.dart';
import '/services/auth_service.dart';

class ManageTripsScreen extends StatefulWidget {
  const ManageTripsScreen({super.key});

  @override
  State<ManageTripsScreen> createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends State<ManageTripsScreen> {
  final TripService _tripService = TripService();
  final AuthService _authService = AuthService();
  String? _agencyId;
  String? _branchId;
  bool _isAdminAgency = false;

  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    var user = await _authService.getCurrentUser();
    if (user != null && user.role == "admin_agency") {
      setState(() {
        _isAdminAgency = true;
        _agencyId = user.uid; // ID de l’agence = ID de l’admin_agency
        _branchId = "default_branch"; // À remplacer avec la vraie branche
      });
    }
  }

  void _addTrip() {
    if (_agencyId != null && _branchId != null) {
      _tripService.addTrip(_agencyId!, _branchId!, {
        'departure_place': _departureController.text,
        'destination': _destinationController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'price': double.parse(_priceController.text),
        'availableSeats': int.parse(_seatsController.text),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdminAgency) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Accès refusé. Seuls les administrateurs d'agence peuvent voir cette page.",
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Gérer les trajets")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _departureController,
                  decoration: const InputDecoration(
                    labelText: "Lieu de départ",
                  ),
                ),
                TextField(
                  controller: _destinationController,
                  decoration: const InputDecoration(labelText: "Destination"),
                ),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Date (AAAA-MM-JJ)",
                  ),
                ),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: "Heure (HH:MM)"),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Prix"),
                ),
                TextField(
                  controller: _seatsController,
                  decoration: const InputDecoration(
                    labelText: "Places disponibles",
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTrip,
                  child: const Text("Ajouter Trajet"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder(
              stream: _tripService.getTrips(_agencyId!, _branchId!),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var trips = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    var trip = trips[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        "${trip['departure_place']} → ${trip['destination']}",
                      ),
                      subtitle: Text(
                        "Départ : ${trip['date']} à ${trip['time']}",
                      ),
                      trailing: Text("${trip['price']} FCFA"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
