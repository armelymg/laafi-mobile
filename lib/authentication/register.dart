import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:laafi/home.dart';
import 'package:laafi/models/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isChecked = false;
  late Utilisateur futureUtilisateur;

  String _name = '';
  String _surname = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _accountType = 'Client'; // Valeur par défaut

  int _currentStep = 0;

  Future<void> _nextStep(Utilisateur utilisateur) async {
    if (_formKey.currentState!.validate()) {
      // Appel de la méthode de connexion
      try {
        // Attendre la réponse de l'authentification
        futureUtilisateur = await AuthController().register(utilisateur);

        // Incrémenter l'étape après une connexion réussie
        setState(() {
          _currentStep++;
        });

        // Si c'est la dernière étape, rediriger vers HomePage
        if (_currentStep == 1) {
          Fluttertoast.showToast(msg: 'Un code OTP vous été envoyé !');
        }
      } catch (e) {
        // Gérer les erreurs d'authentification ici
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : ${e.toString()}')),
        );
      }

    }
  }

  void _verifyOtp() {
    Fluttertoast.showToast(msg: 'OTP vérifié avec succès !');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Column(
        children: [
          Text(
            "S'enregistrer",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
            ),
          ),
          Text(
            "Renseigner vos informations ci-dessous",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            ),
          ),
          SingleChildScrollView(
            // child: _currentStep == 0 ? _registrationForm() : _otpForm(context),
            child: _currentStep == 0 ? _registrationForm() : HomePage(),
          ),
        ],
      )
    );
  }

  Widget _registrationForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) => value!.isEmpty ? 'Entrez votre nom' : null,
                    onChanged: (value) => _name = value,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Prénom',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) => value!.isEmpty ? 'Entrez votre prénom' : null,
                    onChanged: (value) => _surname = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Iconsax.direct),
              ),
              validator: (value) => (value!.isEmpty || !value.contains('@')) ? 'Entrez un email valide' : null,
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 10),

            TextFormField(
              decoration: InputDecoration(
                labelText: "Numéro de téléphone",
                prefixIcon: Icon(Iconsax.call),
              ),
              validator: (value) => value!.isEmpty ? 'Entrez votre numéro de téléphone' : null,
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

            const SizedBox(height: 10),
            // Dropdown pour le type d'utilisateur
            DropdownButtonFormField<String>(
              value: _accountType,
              decoration: InputDecoration(
                labelText: 'Type d\'utilisateur',
                prefixIcon: Icon(Iconsax.user_cirlce_add),
              ),
              items: [
                DropdownMenuItem(value: 'Client', child: Text('Client')),
                DropdownMenuItem(value: 'Responsable Pharmacie', child: Text('Responsable Pharmacie')),
                DropdownMenuItem(value: 'Livreur', child: Text('Livreur')),
              ],
              onChanged: (value) {
                setState(() {
                  _accountType = value!;
                });
              },
              validator: (value) => value == null ? 'Sélectionnez un type d\'utilisateur' : null,
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.blue,
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                const Text(
                    "J'accepte les",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  " termes et conditions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _nextStep(
                    Utilisateur(
                        nom: _name, prenoms: _surname, telephone: _phone,
                        email: _email, password: _password, type: _accountType,
                        isAvailable: false, isEnabled: false
                    )
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Adjust as needed
                ),
              ),
              child: Text(
                  'Enregistrer vous',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpForm(BuildContext context) {
    return Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                onSaved: (pin1) {},
                //decoration: const InputDecoration(hintText: "0"),
                style: Theme.of(context).textTheme.headlineSmall,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                onSaved: (pin2) {},
                //decoration: const InputDecoration(hintText: "1"),
                style: Theme.of(context).textTheme.headlineSmall,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                onSaved: (pin1) {},
                //decoration: const InputDecoration(hintText: "2"),
                style: Theme.of(context).textTheme.headlineSmall,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                onSaved: (pin1) {},
                //decoration: const InputDecoration(hintText: "3"),
                style: Theme.of(context).textTheme.headlineSmall,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
          ],
        )
    );
  }
}