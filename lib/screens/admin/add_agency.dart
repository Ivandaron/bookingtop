import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/firebase_service.dart';

class AddAgency extends StatefulWidget {
  const AddAgency({super.key});

  @override
  _AddAgencyState createState() => _AddAgencyState();
}

class _AddAgencyState extends State<AddAgency> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false; // Pour afficher le chargement

  Future<void> _submitAgency() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String city = _cityController.text.trim();
    String address = _addressController.text.trim();

    try {
      // Appel à FirebaseService pour ajouter une agence
      String generatedPassword = await FirebaseService().addAgency(
        name: name,
        email: email,
        phone: phone,
        city: city,
        address: address,
        role: "admin_agency", // Rôle ajouté automatiquement
      );

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Agence ajoutée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      // Afficher le mot de passe généré dans une boîte de dialogue
      _showPasswordDialog(generatedPassword);

      // Réinitialiser les champs du formulaire
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _cityController.clear();
      _addressController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Erreur : $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Méthode pour afficher une boîte de dialogue avec le mot de passe généré
  void _showPasswordDialog(String password) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Mot de passe généré"),
          content: Text(
            "Le mot de passe pour cette agence est :\n\n$password",
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une agence')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Nouvelle Agence",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      label: "Nom de l'agence",
                      controller: _nameController,
                    ),
                    CustomTextField(
                      label: "Email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      label: "Téléphone",
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    CustomTextField(
                      label: "Ville",
                      controller: _cityController,
                    ),
                    CustomTextField(
                      label: "Adresse",
                      controller: _addressController,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitAgency,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Ajouter",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
