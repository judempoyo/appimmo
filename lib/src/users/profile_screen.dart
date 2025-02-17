import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/users/users_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:appimmo/src/users/users_model.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final SettingsController settingsController;

  const ProfilePage(
      {Key? key, required this.userId, required this.settingsController})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  late User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _userService.getUserById(widget.userId);
    if (user != null) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }

  void _updateProfile() async {
    // Exemple de mise à jour
    await _userService.updateUserById(_user.userId!, {
      'nom': _user.nom,
      'prenom': _user.prenom,
      'email': _user.email,
      'telephone': _user.telephone,
      'adresse': _user.adresse,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil mis à jour avec succès')),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le profil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Nom'),
                  controller: TextEditingController(text: _user.nom),
                  onChanged: (value) {
                    _user.nom = value;
                  },
                ),
                SizedBox(height: 10), // Espacement entre les champs
                TextField(
                  decoration: InputDecoration(labelText: 'Prénom'),
                  controller: TextEditingController(text: _user.prenom),
                  onChanged: (value) {
                    _user.prenom = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: TextEditingController(text: _user.email),
                  onChanged: (value) {
                    _user.email = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Téléphone'),
                  controller: TextEditingController(text: _user.telephone),
                  onChanged: (value) {
                    _user.telephone = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Adresse'),
                  controller: TextEditingController(text: _user.adresse),
                  onChanged: (value) {
                    _user.adresse = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Mettre à jour l'email dans Firebase Auth
                await firebase_auth.FirebaseAuth.instance.currentUser
                    ?.updateEmail(_user.email);
                _updateProfile(); // Mettre à jour le profil dans la base de données
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmNewPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Changer le mot de passe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Mot de passe actuel'),
                  controller: _currentPasswordController,
                  obscureText: true,
                ),
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Nouveau mot de passe'),
                  controller: _newPasswordController,
                  obscureText: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Confirmer le nouveau mot de passe'),
                  controller: _confirmNewPasswordController,
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Vérification du mot de passe actuel
                firebase_auth.User? user =
                    firebase_auth.FirebaseAuth.instance.currentUser;
                firebase_auth.AuthCredential credential =
                    firebase_auth.EmailAuthProvider.credential(
                  email: user!.email!,
                  password: _currentPasswordController.text,
                );

                try {
                  await user.reauthenticateWithCredential(credential);

                  // Vérification des nouveaux mots de passe
                  if (_newPasswordController.text ==
                      _confirmNewPasswordController.text) {
                    await user.updatePassword(_newPasswordController.text);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Mot de passe mis à jour avec succès')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Les mots de passe ne correspondent pas')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mot de passe actuel incorrect')),
                  );
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: _TopPortion(
                settingsController: widget.settingsController,
              )),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '${_user.nom} ${_user.prenom}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_user.email}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200, // Définissez la largeur des boutons
                        child: FloatingActionButton.extended(
                          onPressed: _showEditProfileDialog,
                          heroTag: 'edit',
                          elevation: 0,
                          label: const Text("Modifier le profil"),
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: 200, // Définissez la largeur des boutons
                        child: FloatingActionButton.extended(
                          onPressed: _showChangePasswordDialog,
                          heroTag: 'password',
                          elevation: 0,
                          backgroundColor: Colors.red,
                          label: const Text("Changer le mot de passe"),
                          icon: const Icon(Icons.lock),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileInfoRow(
                    user: _user,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final User user;

  const _ProfileInfoRow({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.telephone,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Téléphone',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.adresse,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Adresse',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  final SettingsController settingsController;
  const _TopPortion({Key? key, required this.settingsController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    settingsController.primaryColor,
                    settingsController.accentColor
                  ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
