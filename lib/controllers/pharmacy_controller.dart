import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laafi/models/pharmacy.dart';
import 'package:laafi/utils/constants.dart';
import 'package:logger/logger.dart';

class PharmacyController {

  final logger = Logger();

  Future<List<Pharmacy>> fetchPharmacies() async {

    try {
      final response = await http.get(Uri.parse(Constants.urlPharmacieGarde));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((pharmacy) => Pharmacy.fromJson(pharmacy)).toList();
      } else {
        throw Exception('Failed to load pharmacies');
      }
    } catch (e) {
      throw Exception('Failed to load pharmacies: $e');

    }

  }
}
