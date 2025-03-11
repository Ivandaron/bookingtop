class BookingModel {
  final String id;
  final String userId;
  final String agencyId;
  final String departure;
  final String destination;
  final DateTime date;
  final String status; // "pending", "confirmed", "canceled"

  BookingModel({
    required this.id,
    required this.userId,
    required this.agencyId,
    required this.departure,
    required this.destination,
    required this.date,
    required this.status,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      userId: map['userId'],
      agencyId: map['agencyId'],
      departure: map['departure'],
      destination: map['destination'],
      date: DateTime.parse(map['date']),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'agencyId': agencyId,
      'departure': departure,
      'destination': destination,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
