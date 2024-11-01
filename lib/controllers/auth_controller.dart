import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:laafi/models/user.dart';
import 'package:laafi/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {

  final logger = Logger();

  Utilisateur? _user;

  Utilisateur? get user => _user;

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

        // Save for preferences
        _user = Utilisateur.fromJson(jsonResponse);
        await _saveUserToPreferences();
        notifyListeners();

        return _user!;
      } else {
        throw Exception('Failed to login: ${response.body}');
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

  Future<void> logout() async {
    _user = null;
    await _removeUserFromPreferences();
    notifyListeners();
  }

  Future<void> _saveUserToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nom', _user!.nom);
    prefs.setString('prenoms', _user!.prenoms);
    prefs.setString('telephone', _user!.telephone);
    prefs.setString('email', _user!.email);
    prefs.setString('password', "");
    prefs.setString('type', _user!.type);
    prefs.setBool('isAvailable', _user!.isAvailable);
    prefs.setBool('isEnabled', _user!.isEnabled);
  }

  Future<void> _removeUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('nom');
    prefs.remove('prenoms');
    prefs.remove('telephone');
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('type');
    prefs.remove('isAvailable');
    prefs.remove('isEnabled');
  }


  Future<void> loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final nom = prefs.getString('nom');
    final prenoms = prefs.getString('prenoms');
    final telephone = prefs.getString('telephone');
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final type = prefs.getString('type');
    final isAvailable = prefs.getBool('isAvailable');
    final isEnabled = prefs.getBool('isEnabled');
    // Vérifie si ces valeurs ne sont pas null et crée un Utilisateur
    if (nom != null && prenoms != null && telephone != null && email != null && password!=null && type !=null && isAvailable!=null && isEnabled!=null) {
      _user = Utilisateur(
        nom: nom,
        prenoms: prenoms,
        telephone: telephone,
        email: email,
        password: password,
        type: type,
        isAvailable: isAvailable,
        isEnabled: isEnabled
      );
      notifyListeners();
    }
  }


}
