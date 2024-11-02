import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:laafi/controllers/commande_controller.dart';
import 'package:laafi/controllers/pharmacy_controller.dart';
import 'package:laafi/controllers/produit_controller.dart';
import 'package:laafi/home.dart';
import 'package:laafi/models/commande.dart';
import 'package:laafi/models/pharmacy.dart';
import 'package:provider/provider.dart';

class CommandeScreen extends StatefulWidget {
  @override
  _CommandeScreenState createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {

  Pharmacy? selectedPharmacy; // Variable pour la pharmacie sélectionnée
  late Future<List<Pharmacy>> futurePharmacies;

  @override
  void initState() {
    super.initState();
    // Remplissez la liste des pharmacies
    futurePharmacies = PharmacyController().fetchPharmacies();
  }

  @override
  Widget build(BuildContext context) {
    final produitController = Provider.of<ProduitController>(context);
    final quantites = produitController.quantites; // Récupérer les quantités du panier
    final produits = produitController.produits; // Récupérer la liste des produits

    final authController = Provider.of<AuthController>(context);

    double totalMontant = 0.0;

    // Calculer le montant total
    quantites.forEach((libelle, quantite) {
      final produit = produits.firstWhere((p) => p.libelle == libelle);
      totalMontant += produit.prix * quantite;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('#Commande'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),

            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: quantites.isEmpty
            ? Center(child: Text("Le panier est vide"))
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: quantites.length,
                itemBuilder: (context, index) {
                  final produitLibelle = quantites.keys.elementAt(index);
                  final quantite = quantites[produitLibelle];
                  print("**************${produits.length}");
                  final produit = produits.firstWhere((p) => p.libelle == produitLibelle);

                  // Calculer le montant total
                  totalMontant += produit.prix * quantite!;

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
                                    onPressed: () {
                                      setState(() {
                                        if (quantites[produit.libelle] != null && quantites[produit.libelle]! > 0) {
                                          quantites[produit.libelle] = quantites[produit.libelle]! - 1;
                                        }
                                      });
                                    },
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
                                    onPressed: () {
                                      setState(() {
                                        quantites[produit.libelle] = (quantites[produit.libelle] ?? 0) + 1;
                                      });
                                    },
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
              ),
            ),

            Text(
                "Choisir la pharmacie"
            ),

            FutureBuilder<List<Pharmacy>>(
              future: futurePharmacies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Affiche un indicateur de chargement
                } else if (snapshot.hasError) {
                  return Text("Erreur lors du chargement des pharmacies");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Aucune pharmacie disponible");
                }

                // Si les pharmacies sont disponibles, créez le dropdown
                return DropdownButton<Pharmacy>(
                  hint: Text("Sélectionnez une pharmacie"),
                  value: selectedPharmacy,
                  onChanged: (Pharmacy? newValue) {
                    setState(() {
                      selectedPharmacy = newValue; // Met à jour la pharmacie sélectionnée
                    });
                  },
                  items: snapshot.data!.map((pharmacy) {
                    return DropdownMenuItem<Pharmacy>(
                      value: pharmacy,
                      child: Text(pharmacy.name),
                    );
                  }).toList(),
                );
              },
            ),

            SizedBox(height: 16),
            Text(
              "Total: ${totalMontant.toStringAsFixed(0)} CFA",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Logique pour passer commande
                // Par exemple, appeler une méthode de l'API pour traiter la commande
                print("Commande passée !");

                try {
                  // Attendre la réponse de la sauvegarde de la commande
                  /*futureUtilisateur =*/ await CommandeController().save(Commande(date: DateTime.now(), montant: totalMontant, produitList: produits, pharmacie: selectedPharmacy!, status: false, localisationClient: GeoPoint(0.0, 0.0), telephoneClient: authController.user!.telephone));

                  // Appel de la page d'accueil
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );

                  Fluttertoast.showToast(msg: 'Votre commande a été enregistré !');
                } catch (e) {
                  // Gérer les erreurs d'authentification ici
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur au niveau de la commande : ${e.toString()}')),
                  );
                }


              },
              child: Text(
                "Passer la Commande",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
