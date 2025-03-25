import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Importez correctement firebase_options.dart
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que Flutter est initialisé
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Utilisez les options générées
  );
  runApp(const BookingTopApp());
}

class BookingTopApp extends StatelessWidget {
  const BookingTopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookingTop',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // Démarre sur l'écran de bienvenue
    );
  }
}
