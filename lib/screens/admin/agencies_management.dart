import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import 'edit_agency.dart';

class AgenciesManagement extends StatelessWidget {
  const AgenciesManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les agences')),
      body: StreamBuilder(
        stream: FirebaseService().agencies.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return const Center(
              child: Text(
                'Aucune agence trouvée.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final agencies = snapshot.data.docs;

          return ListView.builder(
            itemCount: agencies.length,
            itemBuilder: (context, index) {
              final agency = agencies[index];
              final agencyData = agency.data();

              return ListTile(
                title: Text(agencyData['name']),
                subtitle: Text(agencyData['email']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditAgencyScreen(
                                  agencyId: agency.id,
                                  initialName: agencyData['name'],
                                  initialEmail: agencyData['email'],
                                  initialPhone: agencyData['phone'],
                                  initialCity: agencyData['city'],
                                  initialAddress: agencyData['address'],
                                ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await FirebaseService().deleteAgency(agency.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Agence supprimée !')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
