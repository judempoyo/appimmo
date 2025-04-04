import 'package:appimmo/src/admin/properties_screen.dart';
import 'package:appimmo/src/admin/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:appimmo/src/admin/dashboard.dart';
import 'package:appimmo/src/settings/settings_controller.dart';

class AdminBasePage extends StatefulWidget {
  const AdminBasePage({
    super.key,
    required this.title,
    required this.body,
    required this.settingsController,
  });

  final String title;
  final Widget body;
  final SettingsController settingsController;

  @override
  _AdminBasePageState createState() => _AdminBasePageState();
}

class _AdminBasePageState extends State<AdminBasePage> {
  void _onMenuItemSelected(String value) {
    switch (value) {
      case 'settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'profile':
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute<ProfileScreen>(
            builder: (context) => ProfileScreen(
              appBar: AppBar(
                title: const Text('Profil'),
              ),
              actions: [
                SignedOutAction((context) {
                  Navigator.of(context).pop();
                }),
              ],
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('assets/images/test.jpg'),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      case 'logout':
        FirebaseAuth.instance.signOut();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.settingsController.primaryColor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _onMenuItemSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Paramètres'),
                ),
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('Profil'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Déconnexion'),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.settingsController.primaryColor,
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/test.jpg"),
              ),
            ),
            // Tableau de bord
            ListTile(
              leading: Icon(
                Icons.dashboard,
                color: widget.settingsController.primaryColor,
              ),
              title: Text(
                'Tableau de bord',
                style: TextStyle(
                  color: widget.settingsController.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPanel(
                      settingsController: widget.settingsController,
                    ),
                  ),
                );
              },
            ),
            // Utilisateurs
            ListTile(
              leading: Icon(
                Icons.people,
                color: widget.settingsController.primaryColor,
              ),
              title: Text(
                'Utilisateurs',
                style: TextStyle(
                  color: widget.settingsController.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListPage(
                      settingsController: widget.settingsController,
                    ), // Remplacez par votre écran d'utilisateurs
                  ),
                );
              },
            ),
            // Biens Immobiliers
            ListTile(
              leading: Icon(
                Icons.home,
                color: widget.settingsController.primaryColor,
              ),
              title: Text(
                'Biens Immobiliers',
                style: TextStyle(
                  color: widget.settingsController.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyListPage(
                      settingsController: widget.settingsController,
                    ), // Remplacez par votre écran de biens immobiliers
                  ),
                );
              },
            ),

            // Avis
            ListTile(
              leading: Icon(
                Icons.star,
                color: widget.settingsController.primaryColor,
              ),
              title: Text(
                'Avis',
                style: TextStyle(
                  color: widget.settingsController.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReviewsListScreen(), // Remplacez par votre écran d'avis
                  ),
                ); */
              },
            ),
          ],
        ),
      ),
      body: widget.body, // Utiliser le corps passé en paramètre
    );
  }
}
