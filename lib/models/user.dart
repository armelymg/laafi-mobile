
import 'package:laafi/models/pharmacy.dart';

class Utilisateur {

  final String nom;
  final String prenoms;
  final String telephone;
  final String email;
  final String password;
  final String type;
  final bool isAvailable;
  final bool isEnabled;
  final Pharmacy? pharmacie;

  Utilisateur({
    required this.nom,
    required this.prenoms,
    required this.telephone,
    required this.email,
    required this.password,
    required this.type,
    required this.isAvailable,
    required this.isEnabled,
    required this.pharmacie,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      nom: json['nom'] as String,
      prenoms: json['prenoms'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      type: json['type'] as String,
      isAvailable: json['available'] as bool,
      isEnabled: json['enabled'] as bool,
      pharmacie: json['pharmacie'] != null
          ? Pharmacy.fromJson(json['pharmacie'] as Map<String, dynamic>)
          : null,
    );
  }

  // Méthode pour convertir un objet Utilisateur en JSON
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenoms': prenoms,
      'telephone': telephone,
      'email': email,
      'password': password,
      'type': type,
      'available': isAvailable,
      'enabled': isEnabled,
      'pharmacie': pharmacie
    };
  }
}
