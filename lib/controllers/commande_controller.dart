import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:laafi/models/commande.dart';
import 'package:laafi/models/user.dart';
import 'package:laafi/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommandeController with ChangeNotifier {

  final logger = Logger();

  List<Commande> _commandes = []; // Stocke la liste des produits


  Future<Commande> save(Commande commande) async {

    try {

      final response = await http.post(
          Uri.parse('${Constants.urlCommandeSave}'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(commande.toJson())
      );

      print("-------****"+json.encode(commande.toJson()));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        return Commande.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to save commande. Status code: ${response.statusCode}'+json.encode(commande.toJson()));
      }
    } catch (e) {
      throw Exception('Failed to save commande: $e');
    }

  }

  Future<List<Commande>> fetchUserCommande(String telephone) async {

    try {
      final response = await http.get(
        Uri.parse('${Constants.urlFindUserCommande}?tel=${telephone}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        _commandes = jsonResponse.map((commande) => Commande.fromJson(commande)).toList();
        notifyListeners();

        return jsonResponse.map((produit) => Commande.fromJson(produit)).toList();
      } else {
        throw Exception('Failed to load commandes');
      }
    } catch (e) {
      throw Exception('Failed to load commandes: $e');
    }


    // Simuler un appel à une API ou une base de données
    await Future.delayed(Duration(seconds: 2)); // Simule un délai de 2 secondes
    /*return [
      Commande(libelle: "Paracétamol", description: '', prix: 100),
      Commande(libelle: "Amoxiciline", description: '', prix: 500),
      Commande(libelle: "Arthémeter", description: '', prix: 1700),
    ];*/

  }


  Future<List<Commande>> fetchPharmacieCommande(String nom) async {

    try {
      final response = await http.get(
        Uri.parse('${Constants.urlFindPharmacieCommande}?nom=${nom}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        _commandes = jsonResponse.map((commande) => Commande.fromJson(commande)).toList();
        notifyListeners();

        return jsonResponse.map((produit) => Commande.fromJson(produit)).toList();
      } else {
        throw Exception('Failed to load commandes');
      }
    } catch (e) {
      throw Exception('Failed to load commandes: $e');
    }


  }

}
