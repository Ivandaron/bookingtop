import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin/admin_dashboard.dart';
import 'admin/agencies_management.dart';
import 'agency/agency_dashboard.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userRole = ""; // Rôle de l'utilisateur

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  // Méthode pour récupérer le rôle de l'utilisateur depuis Firestore
  Future<void> getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();
      setState(() {
        userRole = userDoc["role"] ?? "client"; // Valeur par défaut = client
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('BookingTop')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user != null ? "Connecté : ${user.email}" : "Non connecté",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (user == null) // Si non connecté, afficher le bouton Connexion
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Se connecter'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            if (user != null) // Si connecté, afficher le bouton Déconnexion
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Se déconnecter'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            if (userRole ==
                "admin") // Dashboard visible uniquement pour "admin"
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard Admin'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminDashboard(),
                    ),
                  );
                },
              ),
            if (userRole == "admin" || userRole == "admin_agency")
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Agences'),
                onTap: () {
                  if (userRole == "admin") {
                    // Rediriger vers la gestion des agences pour les administrateurs
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AgenciesManagement(),
                      ),
                    );
                  } else if (userRole == "admin_agency") {
                    // Rediriger vers le tableau de bord de l'agence
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AgencyDashboardScreen(
                              agencyId: FirebaseAuth.instance.currentUser!.uid,
                            ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Bienvenue sur BookingTop', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
