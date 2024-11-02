import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:laafi/views/header.dart';
import 'package:laafi/views/commande/history_commande.dart';
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
  final TextEditingController _searchController = TextEditingController();
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialiser _pages dans initState
    _pages = [
      PharmacyListPage(
          searchController: _searchController
      ),
      ProduitListPage(
          searchController: _searchController
      ),
      HistoryCommande(),
      ProfileScreen(),

    ];
  }

  @override
  void dispose() {
    _searchController.dispose(); // Libération des ressources
    super.dispose();
  }

  void _onSearchChanged(String query) {
    print("Recherche : $query");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Afficher le HeaderSection et le SearchSection uniquement si l'index n'est pas 2
          if (_currentIndex != 2 && _currentIndex != 3) ...[
            HeaderSection(),
            SearchSection(
              index: _currentIndex,
              searchController: _searchController,
              onChanged: _onSearchChanged, // Passer la fonction ici
            ),
          ],
          Expanded(child: _pages[_currentIndex]), // Use Expanded to fill available space
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.bookmark_add_rounded, size: 30),
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
