import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTripScreen extends StatefulWidget {
  final String agencyId;

  const AddTripScreen({super.key, required this.agencyId});

  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  String busType = "Classique"; // Valeur par défaut

  Future<void> _addTrip() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final int price = int.parse(priceController.text.trim());
      final int seats = int.parse(seatsController.text.trim());

      // Ajouter le trajet dans Firestore avec le champ isBlocked
      await FirebaseFirestore.instance
          .collection('agencies')
          .doc(widget.agencyId)
          .collection('trips')
          .add({
            'departure_place': departureController.text.trim(),
            'destination': destinationController.text.trim(),
            'price': price,
            'availableSeats': seats,
            'busType': busType,
            'isBlocked':
                false, // Ajouter le champ isBlocked avec une valeur par défaut
            'createdAt': Timestamp.now(),
          });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Trajet ajouté avec succès !"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un trajet")),
      body: Padding(
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Nouveau Trajet",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    departureController,
                    "Lieu de départ",
                    Icons.location_on,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    destinationController,
                    "Destination",
                    Icons.flag,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    priceController,
                    "Prix (FCFA)",
                    Icons.attach_money,
                    isNumber: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    seatsController,
                    "Nombre de places",
                    Icons.event_seat,
                    isNumber: true,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: busType,
                    decoration: _inputDecoration(
                      "Type de bus",
                      Icons.directions_bus,
                    ),
                    items:
                        ["Classique", "VIP"]
                            .map(
                              (String value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        busType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Ajouter",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: _inputDecoration(label, icon),
      validator:
          (value) => value == null || value.isEmpty ? "Champ requis" : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }
}
