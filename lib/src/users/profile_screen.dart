import 'package:appimmo/src/users/users_service.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/users/users_model.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

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
    }
  }

  void _updateProfile() async {
    // Exemple de mise à jour
    await _userService.updateUserById(_user.userId!, {
      'prenom': _user.prenom,
      'email': _user.email,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil mis à jour avec succès')),
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
      appBar: AppBar(
        title: Text('Profil de ${_user.prenom}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
              controller: TextEditingController(text: _user.prenom),
              onChanged: (value) {
                _user.prenom = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: _user.email),
              onChanged: (value) {
                _user.email = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Mettre à jour le profil'),
            ),
          ],
        ),
      ),
    );
  }
}
