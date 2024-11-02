import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  final int index;
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;

  const SearchSection({
    Key? key,
    required this.index,
    required this.searchController,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Stack(
        children: [
          TextField(
            controller: searchController,
            onChanged: onChanged,
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
                fontSize: 12,
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