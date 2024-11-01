import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {

    final authController = Provider.of<AuthController>(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 25,
        right: 25
      ),
      //height: 200,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              authController.user != null
                  ? Text(
                  'Bienvenue ${authController.user!.nom}',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )) : Text(
                  'Bienvenue',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
              ),
              SizedBox(height: 5),
              Text(
                "Comment vous sentez-vous aujourd'hui ?",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),

            ],
          ),
          CircleAvatar(
            child: Image.asset(
                'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );

  }
}