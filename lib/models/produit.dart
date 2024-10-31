
class Produit {

  final String libelle;
  final String description;
  final double prix;

  Produit({
    required this.libelle,
    required this.description,
    required this.prix,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      libelle: json['libelle'] as String,
      description: json['description'] as String? ?? "",
      prix: json['prix'] as double,
    );
  }
}
