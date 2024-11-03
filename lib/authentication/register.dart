import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laafi/authentication/login.dart';
import 'package:laafi/controllers/auth_controller.dart';
import 'package:laafi/controllers/pharmacy_controller.dart';
import 'package:laafi/home.dart';
import 'package:laafi/models/pharmacy.dart';
import 'package:laafi/models/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isChecked = false;
  bool _isDropdownOpen = false;
  String? _errorMessage;
  late Utilisateur futureUtilisateur;

  String _name = '';
  String _surname = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _accountType = 'Client'; // Valeur par défaut

  int _currentStep = 0;

  late Future<List<Pharmacy>> _pharmacies;
  List<Pharmacy> _allPharmacies = [];
  List<Pharmacy> _filteredPharmacies = [];
  Pharmacy? _selectedPharmacy;

  @override
  void initState() {
    super.initState();
    _pharmacies = PharmacyController().fetchPharmacies();
  }

  void _filterPharmacies(String value) {
    final query = value.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredPharmacies = _allPharmacies; // Récupérer toutes les pharmacies
      });
    } else {
      setState(() {
        _filteredPharmacies = _allPharmacies
            .where((pharmacy) => pharmacy.name.toLowerCase().contains(query))
            .toList(); // Filtrer les pharmacies selon la recherche
      });
    }
  }


  Future<void> _nextStep(Utilisateur utilisateur) async {
    _validateCheckbox();
    if (_formKey.currentState!.validate()) {
      // Appel de la méthode de connexion
      try {
        // Attendre la réponse de l'authentification
        futureUtilisateur = await AuthController().register(utilisateur);

        // Incrémenter l'étape après une connexion réussie
        setState(() {
          _currentStep++;
        });

        // Appel de la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

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
      body: SingleChildScrollView(
        child: Column(
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
        ),
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
                  if (_accountType != 'Responsable Pharmacie') {
                    _selectedPharmacy = null; // Réinitialiser la sélection si ce n'est pas un responsable
                    _filteredPharmacies = _allPharmacies; // Réinitialiser la liste
                  }
                });
              },
              validator: (value) => value == null ? 'Sélectionnez un type d\'utilisateur' : null,
            ),

            const SizedBox(height: 25),

            if (_accountType == 'Responsable Pharmacie') ...[

              FutureBuilder<List<Pharmacy>>(
                future: _pharmacies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {

                    if (_allPharmacies.isEmpty && snapshot.connectionState == ConnectionState.done) {
                      _allPharmacies = snapshot.data ?? [];
                      _filteredPharmacies = _allPharmacies; // Assurez-vous que _filteredPharmacies est mise à jour
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Veuillez indiquer votre pharmacie',
                              prefixIcon: Icon(Icons.local_pharmacy_outlined),
                            ),
                            onChanged: _filterPharmacies,
                            onTap: () {
                              setState(() {
                                _isDropdownOpen = true; // Ouvrir le dropdown lors du tap
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          if (_isDropdownOpen) ...[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                children: _filteredPharmacies.map((pharmacy) {
                                  return ListTile(
                                    title: Text("Pharmacie ${pharmacy.name}"),
                                    onTap: () {
                                      setState(() {
                                        _selectedPharmacy = pharmacy;
                                        _searchController.text = pharmacy.name; // Mettre à jour le champ de recherche
                                        _isDropdownOpen = false; // Fermer le dropdown
                                        //_filteredPharmacies = widget.pharmacies; // Réinitialiser la liste
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          if (_selectedPharmacy != null)
                            Text("Pharmacie sélectionnée : ${_selectedPharmacy?.name}"),

                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text('Pas de données trouvées.'));
                  }
                },
              ),


            ],

            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.blue,
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                      _errorMessage = null; // Réinitialiser le message d'erreur lors du changement
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
                        isAvailable: false, isEnabled: false, pharmacie: _selectedPharmacy
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

            const SizedBox(height: 70),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Avez-vous déjà un compte? "
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()), // Remplace par ta page d'enregistrement
                    );
                  },
                  child: Text(
                    "Connectez vous!",
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

  void _validateCheckbox() {
    setState(() {
      if (!_isChecked) {
        _errorMessage = 'Vous devez accepter les conditions.';
        Fluttertoast.showToast(msg: "Vous devez accepter les conditions.");

      } else {
        _errorMessage = null; // Réinitialiser le message d'erreur si validé
      }
    });
  }

}
