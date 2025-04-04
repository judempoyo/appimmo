import 'package:appimmo/src/admin/properties_screen.dart';
import 'package:appimmo/src/admin/users_screen.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key, required this.settingsController})
      : super(key: key);

  final SettingsController settingsController;

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final Map<String, int> _counts = {
    'users': 0,
    'properties': 0,
    'reviews': 0,
  };
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCounts();
  }

  Future<void> _getCounts() async {
    setState(() {
      _isLoading = true;
    });
    for (final key in _counts.keys) {
      final snapshot = await _database.ref(key).get();
      setState(() {
        _counts[key] = snapshot.exists ? snapshot.children.length : 0;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildCountCard(String title, int count, Widget page, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => _navigateTo(context, page),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIcon(title),
                    size: screenWidth * 0.08,
                    color: Colors.white,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String title) {
    switch (title) {
      case 'Utilisateurs':
        return Icons.people;
      case 'Biens Immobiliers':
        return Icons.home;
      case 'Avis':
        return Icons.star;

      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Déterminer le nombre de colonnes en fonction de la largeur de l'écran
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 1; // Petits écrans
    } else if (screenWidth < 1200) {
      crossAxisCount = 3; // Écrans moyens
    } else {
      crossAxisCount = 4; // Grands écrans
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Administrateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCounts,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio:
                    3, // Ajuster le ratio pour une meilleure présentation
                children: [
                  _buildCountCard(
                    'Utilisateurs',
                    _counts['users']!,
                    UserListPage(
                      settingsController: widget.settingsController,
                    ),
                    widget.settingsController.primaryColor,
                  ),
                  _buildCountCard(
                    'Biens Immobiliers',
                    _counts['properties']!,
                    PropertyListPage(
                        settingsController: widget.settingsController),
                    widget.settingsController.primaryColor,
                  ),
                  _buildCountCard(
                    'Avis',
                    _counts['reviews']!,
                    Text('Reviews Page'),
                    widget.settingsController.primaryColor,
                  ),
                ],
              ),
      ),
    );
  }
}
