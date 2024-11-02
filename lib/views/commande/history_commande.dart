import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laafi/authentication/login.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:laafi/controllers/commande_controller.dart';
import 'package:laafi/models/commande.dart';
import 'package:laafi/views/commande/commande_overview.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:provider/provider.dart';

class HistoryCommande extends StatefulWidget {
  HistoryCommande({Key? key}) : super(key: key);

  @override
  _HistoryCommandeState createState() => _HistoryCommandeState();
}

class _HistoryCommandeState extends State<HistoryCommande> {
  late Future<List<Commande>> futureCommandes;
  List<Commande>? _allCommandes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    futureCommandes = CommandeController().fetchUserCommande(authController.user!.telephone);


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              "Historique des commandes",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder<List<Commande>>(
              future: futureCommandes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else {
                  _allCommandes = snapshot.data;

                  return Container(
                    height: MediaQuery.of(context).size.height, // Définit une hauteur pour le ListView
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: _allCommandes?.length ?? 0,
                      itemBuilder: (context, index) {
                        final commande = _allCommandes![index]; // Accéder à la pharmacie

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8.0),
                            minLeadingWidth: 8,
                            leading: Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Qté : "+commande.produitList.length.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      commande.montant.toString()+" CFA",
                                      style: TextStyle(color: Colors.white),
                                    )
                                )
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Pharmacie "+commande.pharmacie.name),
                                      Text(""+commande.date!.day.toString()+"-"+commande.date!.month.toString()+"-"+commande.date!.year.toString())
                                    ],
                                  ),
                                ),
                                commande.status ? Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Valider",
                                      style: TextStyle(color: Colors.white),
                                    )
                                ) : Text(
                                  "En cours",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {

                              print("Tap on commande");

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => CommandeScreen()),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }


}
