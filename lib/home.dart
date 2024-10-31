import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:laafi/views/header.dart';
import 'package:laafi/views/pharmacies_garde_overview.dart';
import 'package:laafi/views/produit_view.dart';
import 'package:laafi/views/search.dart';
import 'package:laafi/views/user_profile.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    PharmacyListPage(),
    ProduitListPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Afficher le HeaderSection et le SearchSection uniquement si l'index n'est pas 2
          if (_currentIndex != 2) ...[
            HeaderSection(),
            SearchSection(index: _currentIndex),
          ],
          Expanded(child: _pages[_currentIndex]), // Use Expanded to fill available space
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color: Colors.blue,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
