import 'package:flutter/material.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:laafi/home.dart';
import 'dart:async';

import 'package:laafi/on_boarding.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserAndNavigate();
  }

  Future<void> _loadUserAndNavigate() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.loadUserFromPreferences();

    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => authController.user!=null ? HomePage() : OnBoarding(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 65), // Espacement entre le logo et le texte
            Text(
              'Développé par',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'B. Armel YAMEOGO',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Walker COMPAORE',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

