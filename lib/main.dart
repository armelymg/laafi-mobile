import 'package:flutter/material.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:laafi/controllers/produit_controller.dart';
import 'package:laafi/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController()..loadUserFromPreferences(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProduitController()..fetchProduitsPageable(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laafi Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
