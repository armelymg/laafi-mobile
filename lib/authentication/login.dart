import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laafi/authentication/register.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:laafi/home.dart';
import 'package:laafi/models/user.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  late Utilisateur futureUtilisateur;

  String _phone = '';
  String _password = '';

  int _currentStep = 0;

  void _nextStep(String telephone, String password) async {
    if (_formKey.currentState!.validate()) {

      try {
        // Attendre la réponse de l'authentification
        final authController = Provider.of<AuthController>(context, listen: false);
        futureUtilisateur = await authController.login(telephone, password);

        // Incrémenter l'étape après une connexion réussie
        setState(() {
          _currentStep++;
        });

        // Si c'est la dernière étape, rediriger vers HomePage
        if (_currentStep == 1) {
          Fluttertoast.showToast(msg: 'Connexion réussie !');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        // Gérer les erreurs d'authentification ici
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : ${e.toString()}')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Column(
        children: [
          Text(
              "Se connecter",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            "Ravi de vous revoir parmi nous!",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
          ),
          SingleChildScrollView(
              child:  _loginForm()
          )
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Numéro de téléphone",
                prefixIcon: Icon(Iconsax.user_edit),
              ),
              validator: (value) => value!.isEmpty ? 'Entrez votre uméro de téléphone' : null,
              onChanged: (value) => _phone = value,
            ),
            const SizedBox(height: 10),

            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
              validator: (value) => (value!.length < 6) ? 'Le mot de passe doit contenir au moins 6 caractères' : null,
              onChanged: (value) => _password = value,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _nextStep(_phone, _password);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Adjust as needed
                ),
              ),
              child: Text(
                  'Connecter vous',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            const SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Pas encore de compte? "
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()), // Remplace par ta page d'enregistrement
                    );
                  },
                  child: Text(
                    "Enregistrez vous!",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
