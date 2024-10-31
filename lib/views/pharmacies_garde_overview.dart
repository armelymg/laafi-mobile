import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    futurePharmacies = PharmacyController().fetchPharmacies();
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
            return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: pharmacies.length,
                itemBuilder: (context, index) {
                  final pharmacy = pharmacies[index];
                  final localisation = pharmacy.localisation;
                  final latitude = localisation['latitude'] ?? 0.0;
                  final longitude = localisation['longitude'] ?? 0.0;

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
                        ],
                      ),
                      onTap: () {
                        _launchMapsUrl(latitude, longitude);
                        // Navigue vers la page d'itinéraire
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapsItineraryPage(latitude: latitude, longitude: longitude),
                          ),
                        );*/
                      },
                    ),
                  );
                });
          }
        },),
    );
  }
}
