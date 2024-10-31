import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laafi/models/user.dart';
import 'package:laafi/utils/constants.dart';
import 'package:logger/logger.dart';

class AuthController {

  final logger = Logger();

  Future<Utilisateur> login(String telephone, String password) async {

    try {
      final response = await http.get(
        Uri.parse('${Constants.urlLogin}?tel=$telephone&password=$password'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Utilisateur.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Utilisateur> register(Utilisateur utilisateur) async {

    try {
      final response = await http.post(
        Uri.parse('${Constants.urlRegister}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(utilisateur.toJson())
      );

      print(json.encode(utilisateur.toJson()));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Utilisateur.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to register. Status code: ${response.statusCode}'+json.encode(utilisateur.toJson()));
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }

  }

}
