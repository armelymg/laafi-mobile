import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:laafi/controllers/pharmacy_controller.dart';
import 'package:laafi/models/pharmacy.dart';
import 'package:laafi/views/itineraire_maps.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyListPage extends StatefulWidget {

  @override
  _PharmacyListPageState createState() => _PharmacyListPageState();

}

class _PharmacyListPageState extends State<PharmacyListPage> {

  late Future<List<Pharmacy>> futurePharmacies;
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    futurePharmacies = PharmacyController().fetchPharmacies();
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
            final pharmacies = snapshot.data!;

            // Trier les pharmacies par distance
            List<Map<String, dynamic>> pharmaciesWithDistance = pharmacies.map((pharmacy) {
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
                itemCount: pharmacies.length,
                itemBuilder: (context, index) {
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
                      title: Text(pharmacy.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(pharmacy.localisation),
                          Text(pharmacy.phone.toString()),
                          Text('Distance : ${distance.toStringAsFixed(2)} km'),
                        ],
                      ),
                      onTap: () {
                        // Navigue vers la page d'itinéraire
                        _launchMapsUrl(pharmacy.localisation['latitude'], pharmacy.localisation['longitude']);
                        //_launchMapsUrl(latitude, longitude);
                      },
                    ),
                  );
                });
          }
        },),
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
