import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  final int index;

  const SearchSection({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Stack(
        children: [
          TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none
                )
              ),
              prefixIcon: const Icon(
                Icons.search_outlined,
                size: 30,
              ),
              hintText: index==0 ? "Rechercher les pharmacies" : "Rechercher le prix d'un médicament",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.7)
              )
            ),
          ),
          Positioned(
            right: 12,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Icon(
                  Icons.mic_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              )
          )
        ],
      ),
    );

  }
}