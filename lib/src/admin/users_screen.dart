// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:appimmo/src/users/users_model.dart';
import 'package:appimmo/src/users/users_service.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final UserService _userService = UserService();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _userService.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  void _navigateToUserForm(BuildContext context, {User? user}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserFormScreen(user: user),
      ),
    ).then((_) => _loadUsers());
  }

  void _deleteUser(String userId) async {
    await _userService.deleteUser(userId);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToUserForm(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text('${user.nom} ${user.prenom}'),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToUserForm(context, user: user),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteUser(user.userId!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  late String _nom;
  late String _prenom;
  late String _email;
  late String _role;
  late String _telephone;
  late String _adresse;
  late String _motDePasse;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nom = widget.user!.nom;
      _prenom = widget.user!.prenom;
      _email = widget.user!.email;
      _role = widget.user!.role;
      _telephone = widget.user!.telephone;
      _adresse = widget.user!.adresse;
      _motDePasse = widget.user!.motDePasse;
    } else {
      _nom = '';
      _prenom = '';
      _email = '';
      _role = '';
      _telephone = '';
      _adresse = '';
      _motDePasse = '';
    }
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = User(
        userId: widget.user?.userId ?? '',
        nom: _nom,
        prenom: _prenom,
        email: _email,
        role: _role,
        telephone: _telephone,
        adresse: _adresse,
        motDePasse: _motDePasse,
      );

      if (widget.user == null) {
        await _userService.createUser(user);
      } else {
        await _userService.updateUser(user);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null
            ? 'Ajouter un Utilisateur'
            : 'Modifier un Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nom,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un nom' : null,
                onSaved: (value) => _nom = value!,
              ),
              TextFormField(
                initialValue: _prenom,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un prénom' : null,
                onSaved: (value) => _prenom = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un email' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Rôle'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un rôle' : null,
                onSaved: (value) => _role = value!,
              ),
              TextFormField(
                initialValue: _telephone,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer un numéro de téléphone'
                    : null,
                onSaved: (value) => _telephone = value!,
              ),
              TextFormField(
                initialValue: _adresse,
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer une adresse' : null,
                onSaved: (value) => _adresse = value!,
              ),
              TextFormField(
                initialValue: _motDePasse,
                decoration: const InputDecoration(labelText: 'Mot de Passe'),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
                onSaved: (value) => _motDePasse = value!,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
