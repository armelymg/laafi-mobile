import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:laafi/controllers/pharmacy_controller.dart';
import 'package:laafi/models/pharmacy.dart';
import 'package:laafi/views/itineraire_maps.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyListPage extends StatefulWidget {

  final TextEditingController searchController;

  PharmacyListPage({Key? key, required this.searchController}) : super(key: key);

  @override
  _PharmacyListPageState createState() => _PharmacyListPageState();

}

class _PharmacyListPageState extends State<PharmacyListPage> {

  late Future<List<Pharmacy>> futurePharmacies;
  double? userLatitude;
  double? userLongitude;

  List<Pharmacy> _allPharmacies = [];
  List<Pharmacy> _filteredPharmacies = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    futurePharmacies = PharmacyController().fetchPharmacies();
    widget.searchController.addListener(_filterPharmacies); // Écoute les changements de texte
  }

  void _filterPharmacies() {
    final query = widget.searchController.text.toLowerCase();
    if (_allPharmacies.isNotEmpty) {
      setState(() {
        _filteredPharmacies = _allPharmacies.where((pharmacy) {
          return pharmacy.name.toLowerCase().contains(query) ||
              pharmacy.phone.toString().contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_filterPharmacies); // Enlever l'écouteur
    super.dispose();
  }

  void _getUserLocation() async {
    // Vérifier les permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Gestion de l'absence de permissions
        return;
      }
    }

    // Récupérer la localisation
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
      // Recharger la liste des pharmacies si nécessaire
      futurePharmacies = PharmacyController().fetchPharmacies();
    });
  }

  void _launchMapsUrl(double latitude, double longitude) async {
    final Uri _url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Pharmacy>>(
        future: futurePharmacies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else {

            if (_allPharmacies.isEmpty && snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _allPharmacies = snapshot.data ?? [];
                  _filterPharmacies(); // Filtrez après avoir mis à jour _allPharmacies
                });
              });
            }

            // Trier les pharmacies par distance
            List<Map<String, dynamic>> pharmaciesWithDistance = _filteredPharmacies.map((pharmacy) {
              final lat = pharmacy.localisation['latitude'] ?? 0.0;
              final lon = pharmacy.localisation['longitude'] ?? 0.0;
              final distance = calculateDistance(userLatitude!, userLongitude!, lat, lon);
              return {
                'pharmacy': pharmacy,
                'distance': distance,
              };
            }).toList();

            // Tri par distance
            pharmaciesWithDistance.sort((a, b) => a['distance'].compareTo(b['distance']));


            return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: _filteredPharmacies.length ?? 0, // Gérer les listes nulles
                itemBuilder: (context, index) {

                  // Vérifiez si la liste est nulle ou si l'index est en dehors des limites
                  if (pharmaciesWithDistance == null || index >= pharmaciesWithDistance.length) {
                    return SizedBox.shrink();
                  }

                  final pharmacyData = pharmaciesWithDistance[index];
                  final pharmacy = pharmacyData['pharmacy'];
                  final distance = pharmacyData['distance'];

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
                      title: Text(
                          pharmacy.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pharmacy.phone.toString()),
                              ],
                            ),
                          ),
                          distance < 100 ? Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${distance.toStringAsFixed(2)} km",
                                style: TextStyle(color: Colors.white),
                              )
                          ) : Text(
                              "Localisation indisponible",
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

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmation"),
                              content: Text("Rechercher l'itinéraire de la pharmacie ${pharmacy.name} ?"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Annuler"),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Fermer la boîte de dialogue
                                  },
                                ),
                                TextButton(
                                  child: Text("Oui"),
                                  onPressed: () {
                                    // Navigue vers la page d'itinéraire
                                    _launchMapsUrl(pharmacy.localisation['latitude'], pharmacy.localisation['longitude']);
                                    //_launchMapsUrl(latitude, longitude);
                                  },
                                ),
                              ],
                            );
                          },
                        );

                      },
                    ),
                  );
                });
            }
        },
      ),
    );
  }

  // Méthode pour calculer la distance
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Rayon de la Terre en kilomètres
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance en kilomètres
  }

}
