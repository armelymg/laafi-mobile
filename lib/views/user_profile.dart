import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Votre profil", style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? Icons.sunny : Icons.shield_moon),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: const Image(
                        image: AssetImage("assets/images/logo.png"), // Assure-toi du chemin
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("John DOE", style: Theme.of(context).textTheme.headlineMedium),
              Text("Livreur", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("Modifier le profil", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.5, // Ajuste la hauteur selon tes besoins
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Votre profil'),
                      onTap: () {
                        // Implémenter l'action pour "Votre profil" ici
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Paramètres'),
                      onTap: () {
                        // Implémenter l'action pour "Paramètres" ici
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded),
                      title: Text("Centre d'aide"),
                      onTap: () {
                        // Implémenter l'action pour "Paramètres" ici
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.safety_check),
                      title: Text("Politique de confidentialité"),
                      onTap: () {
                        // Implémenter l'action pour "Paramètres" ici
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout_rounded),
                      title: Text("Se déconnecter"),
                      onTap: () {
                        // Implémenter l'action pour "Paramètres" ici
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
