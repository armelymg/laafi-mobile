import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laafi/models/pharmacy.dart';
import 'package:laafi/models/produit.dart';
import 'package:laafi/utils/constants.dart';
import 'package:logger/logger.dart';

class ProduitController {

  final logger = Logger();

  Future<List<Produit>> fetchProduitsPageable() async {

    try {
      final response = await http.get(
        Uri.parse('${Constants.urlProduitPageable}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> produitsList = jsonResponse['content'];
        return produitsList.map((produit) => Produit.fromJson(produit)).toList();
      } else {
        throw Exception('Failed to load produits');
      }
    } catch (e) {
      throw Exception('Failed to load produits: $e');
    }


    // Simuler un appel à une API ou une base de données
    await Future.delayed(Duration(seconds: 2)); // Simule un délai de 2 secondes
    return [
      Produit(libelle: "Paracétamol", description: '', prix: 100),
      Produit(libelle: "Amoxiciline", description: '', prix: 500),
      Produit(libelle: "Arthémeter", description: '', prix: 1700),
    ];

  }
}
