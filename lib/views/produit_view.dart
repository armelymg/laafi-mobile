import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laafi/controllers/produit_controller.dart';
import 'package:laafi/models/produit.dart';
import 'package:laafi/views/panier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProduitListPage extends StatefulWidget {
  @override
  _ProduitListPageState createState() => _ProduitListPageState();
}

class _ProduitListPageState extends State<ProduitListPage> {

  late Future<List<Produit>> futureProduits;
  Map<String, int> quantites = {}; // Map pour stocker les quantités sélectionnées

  @override
  void initState() {
    super.initState();
    futureProduits = ProduitController().fetchProduitsPageable();
  }

  void _incrementQuantite(String produitLibelle) {
    setState(() {
      quantites[produitLibelle] = (quantites[produitLibelle] ?? 0) + 1;
    });
  }

  void _decrementQuantite(String produitLibelle) {
    setState(() {
      if (quantites[produitLibelle] != null && quantites[produitLibelle]! > 0) {
        quantites[produitLibelle] = quantites[produitLibelle]! - 1;
      }
    });
  }

  double _calculerMontantTotal(List<Produit> produits) {
    double total = 0.0;
    quantites.forEach((libelle, quantite) {
      if (quantite > 0) {
        // Obtenir le prix du produit correspondant
        final produit = produits.firstWhere((p) => p.libelle == libelle, orElse: () => Produit(libelle: libelle, description: "",prix: 0.0));
        total += produit.prix * quantite; // Multiplier par la quantité
      }
    });
    return total;
  }

  int get quantiteTotale {
    return quantites.values.fold(0, (sum, quantite) => sum + quantite);
  }

  void _passerCommande() {
    // Logique pour passer la commande
    // Vous pouvez ici compiler les produits et leurs quantités et les envoyer à votre backend
    final produitsCommandes = quantites.entries.where((entry) => entry.value > 0).toList();
    if (produitsCommandes.isNotEmpty) {
      // Par exemple, envoyer ces informations au serveur
      print("Produits commandés : $produitsCommandes");
    } else {
      print("Aucun produit sélectionné.");
    }
  }

  @override
  Widget build(BuildContext context) {

    final produitController = Provider.of<ProduitController>(context);

    return Scaffold(
      body: FutureBuilder<List<Produit>>(
        future: futureProduits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else {
            final produits = snapshot.data!;
            final totalMontant = _calculerMontantTotal(produits); // Calculez le montant total ici
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(0.3),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(  // Utilisation de Expanded ici
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Montant total: ${totalMontant.toStringAsFixed(2)} CFA",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espace entre les enfants
                                children: [
                                  Expanded(  // Utilisation de Expanded pour prendre tout l'espace disponible
                                    child: Text(
                                      "Quantité : ${quantiteTotale}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(width: 8),  // Un petit espace entre le texte et les boutons
                                  ElevatedButton(
                                    onPressed: () {
                                      // Logique pour vider le panier
                                      setState(() {
                                        quantites = {};
                                      });
                                    },
                                    child: Text("Vider", style: TextStyle(color: Colors.white)),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                    ),
                                  ),
                                  SizedBox(width: 8),  // Un petit espace entre les boutons
                                  ElevatedButton(
                                    onPressed: () {
                                      // Logique pour naviguer vers le panier
                                      Provider.of<ProduitController>(context, listen: false).setQuantites(quantites);

                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => PanierScreen(),
                                      ));
                                    },
                                    child: Text(
                                      "Voir le Panier",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white)// Limiter à une seule ligne
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: produits.length,
                      itemBuilder: (context, index) {
                        final produit = produits[index];
                        final quantite = quantites[produit.libelle] ?? 0;

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded( // Utilisation de Expanded
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produit.libelle,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        produit.prix.floor().toString() + " CFA",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(CupertinoIcons.minus, color: Colors.white,),
                                          onPressed: () => _decrementQuantite(produit.libelle),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          quantite.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () => _incrementQuantite(produit.libelle),
                                          icon: Icon(
                                            CupertinoIcons.plus,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                )
              ],
            );
          }
        },
      ),
    );

  }
}
