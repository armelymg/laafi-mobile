import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laafi/models/pharmacy.dart';
import 'package:laafi/models/produit.dart';

class Commande {
  DateTime? date; // Utilisez DateTime au lieu de Date
  double montant;
  bool status;
  GeoPoint? localisationClient;
  String telephoneClient;
  List<Produit> produitList; // Assurez-vous que la classe Produit est définie
  Pharmacy pharmacie; // Assurez-vous que la classe Pharmacie est définie

  Commande({
    required this.date,
    required this.montant,
    required this.status,
    required this.localisationClient,
    required this.telephoneClient,
    required this.produitList,
    required this.pharmacie,
  });

  // Méthode pour créer une instance de Commande à partir d'un DocumentSnapshot
  factory Commande.fromSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>?;
    if (data != null) {
      return Commande(
        date: (data['date'] as Timestamp).toDate(),
        montant: (data['montant'] as num).toDouble(),
        status: data['status'] as bool,
        localisationClient: data['localisationClient'] != null
            ? GeoPoint(
          (data['localisationClient']['latitude'] as num).toDouble(),
          (data['localisationClient']['longitude'] as num).toDouble(),
        )
            : null,
        telephoneClient: data['telephoneClient'] as String,
        produitList: (data['produitList'] as List<dynamic>).map((item) {
          return Produit.fromJson(item as Map<String, dynamic>);
        }).toList(),
        pharmacie: Pharmacy.fromJson(data['pharmacie'] as Map<String, dynamic>),
      );
    } else {
      // Gestion d'une absence de données (si nécessaire)
      throw Exception('No data available for this document');
    }
  }


  // Méthode pour créer une instance de Commande à partir d'un JSON
  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      montant: (json['montant'] as num).toDouble(),
      status: json['status'] as bool,
      localisationClient: json['localisationClient']!= null
          ? GeoPoint(json['localisationClient']['latitude'], json['localisationClient']['longitude'])
          : null,
      telephoneClient: json['telephoneClient'] as String,
      produitList: (json['produitList'] as List<dynamic>).map((item) {
        return Produit.fromJson(item as Map<String, dynamic>);
      }).toList(),
      pharmacie: Pharmacy.fromJson(json['pharmacie'] as Map<String, dynamic>),
    );
  }

  // Méthode pour convertir l'objet Commande en Map pour JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date != null ? date!.millisecondsSinceEpoch : null, // Convertir en millisecondes
      'montant': montant,
      'status': status,
      'localisationClient': {
        'latitude': localisationClient?.latitude,
        'longitude': localisationClient?.longitude,
      },
      'telephoneClient': telephoneClient,
      'produitList': produitList.map((produit) => produit.toJson()).toList(),
      'pharmacie': pharmacie.toJson(),
    };
  }

}
