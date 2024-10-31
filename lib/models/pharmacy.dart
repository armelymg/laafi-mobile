
class Pharmacy {
  final String name;
  final Map<String, dynamic> localisation;
  final int phone;
  final int groupe;
  // final String openingHours;

  Pharmacy({
    required this.name,
    required this.localisation,
    required this.phone,
    required this.groupe,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      name: json['pharmacie'] as String,
      localisation: json['localisation'] as Map<String, dynamic>? ?? {},
      phone: json['telephone'] as int,
      groupe: json['groupe'] as int,
    );
  }
}
