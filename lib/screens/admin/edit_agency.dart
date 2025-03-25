import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';

class EditAgencyScreen extends StatefulWidget {
  final String agencyId;
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialCity;
  final String initialAddress;

  const EditAgencyScreen({
    super.key,
    required this.agencyId,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialCity,
    required this.initialAddress,
  });

  @override
  _EditAgencyScreenState createState() => _EditAgencyScreenState();
}

class _EditAgencyScreenState extends State<EditAgencyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _cityController = TextEditingController(text: widget.initialCity);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateAgency() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseService().updateAgency(
      agencyId: widget.agencyId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agence mise à jour avec succès !')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier l'agence")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom de l'agence"),
                validator:
                    (value) => value!.isEmpty ? "Ce champ est requis" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator:
                    (value) => value!.isEmpty ? "Ce champ est requis" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
                validator:
                    (value) => value!.isEmpty ? "Ce champ est requis" : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "Ville"),
                validator:
                    (value) => value!.isEmpty ? "Ce champ est requis" : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
                validator:
                    (value) => value!.isEmpty ? "Ce champ est requis" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateAgency,
                child: const Text("Mettre à jour"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
