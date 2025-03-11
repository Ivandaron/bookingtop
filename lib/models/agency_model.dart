class AgencyModel {
  final String id;
  final String name;
  final String city;
  final String address;
  final String ownerId; // ID du responsable de l’agence

  AgencyModel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.ownerId,
  });

  factory AgencyModel.fromMap(Map<String, dynamic> map) {
    return AgencyModel(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      address: map['address'],
      ownerId: map['ownerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'ownerId': ownerId,
    };
  }
}
