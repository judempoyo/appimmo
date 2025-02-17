import 'dart:io';

import 'package:appimmo/src/users/users_model.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/users/users_service.dart';

class UserListPage extends StatefulWidget {
  final SettingsController settingsController;

  const UserListPage({super.key, required this.settingsController});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilisateurs'),
      ),
      body: FutureBuilder(
        future: _userService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data![index].nom,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      widget.settingsController.primaryColor),
                            ),
                            PopupMenuButton(
                              icon: Icon(Icons.more_horiz),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.remove_red_eye),
                                      SizedBox(width: 10),
                                      Text('Voir l\'utilisateur'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserFormPage(
                                          user: snapshot.data![index],
                                          settingsController:
                                              widget.settingsController,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 10),
                                      Text('Modifier'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserFormPage(
                                          user: snapshot.data![index],
                                          settingsController:
                                              widget.settingsController,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(width: 10),
                                      Text('Supprimer'),
                                    ],
                                  ),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            'Voulez-vous vraiment supprimer cet utilisateur ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Non'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _userService.deleteUser(
                                                  snapshot
                                                      .data![index].userId!);
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: Text('Oui'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data![index].prenom,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserFormPage(
                      settingsController: widget.settingsController,
                    )),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: widget.settingsController.primaryColor,
      ),
    );
  }
}

class UserFormPage extends StatefulWidget {
  final User? user;
  final SettingsController settingsController;

  UserFormPage({this.user, required this.settingsController});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  String _nom = '';
  String _prenom = '';
  String _email = '';
  String _motDePasse = '';
  String _avatar = '';
  String _role = '';
  String _telephone = '';
  String _adresse = '';
  DateTime _dateInscription = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nom = widget.user!.nom;
      _prenom = widget.user!.prenom;
      _email = widget.user!.email;
      _motDePasse = widget.user!.motDePasse;
      _avatar = widget.user!.avatar;
      _role = widget.user!.role;
      _telephone = widget.user!.telephone;
      _adresse = widget.user!.adresse;
      _dateInscription = widget.user!.dateInscription;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.user != null ? 'Modifier utilisateur' : 'Créer utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _nom,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un nom';
                    }
                    return null;
                  },
                  onSaved: (value) => _nom = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _prenom,
                  decoration: InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un prénom';
                    }
                    return null;
                  },
                  onSaved: (value) => _prenom = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _motDePasse,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un mot de passe';
                    }
                    return null;
                  },
                  onSaved: (value) => _motDePasse = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    if (pickedFile != null) {
                      setState(() {
                        _avatar = pickedFile.files.first.path!;
                      });
                    }
                  },
                  child: Text('Télécharger l\'avatar'),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _avatar.isNotEmpty ? FileImage(File(_avatar)) : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Rôle',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('Administrateur'),
                      value: 'Administrateur',
                    ),
                    DropdownMenuItem(
                      child: Text('Agent'),
                      value: 'Agent',
                    ),
                    DropdownMenuItem(
                      child: Text('Utilisateur'),
                      value: 'Utilisateur',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _role = value as String;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un rôle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _telephone,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un téléphone';
                    }
                    return null;
                  },
                  onSaved: (value) => _telephone = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _adresse,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez une adresse';
                    }
                    return null;
                  },
                  onSaved: (value) => _adresse = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.user != null
                      ? 'Modifier utilisateur'
                      : 'Créer utilisateur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.settingsController.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.user != null) {
        await _userService.updateUser(User(
          userId: widget.user!.userId,
          nom: _nom,
          prenom: _prenom,
          email: _email,
          motDePasse: _motDePasse,
          avatar: _avatar,
          role: _role,
          telephone: _telephone,
          adresse: _adresse,
          dateInscription: _dateInscription,
        ));
      } else {
        await _userService.createUser(User(
          nom: _nom,
          prenom: _prenom,
          email: _email,
          motDePasse: _motDePasse,
          avatar: _avatar,
          role: _role,
          telephone: _telephone,
          adresse: _adresse,
          dateInscription: _dateInscription,
        ));
      }
      Navigator.pop(context);
    }
  }
}
