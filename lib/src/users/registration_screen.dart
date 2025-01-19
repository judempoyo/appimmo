import 'package:flutter/material.dart';
import 'package:appimmo/src/home/home_view.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'dart:ui'; // Pour ImageFilter
import 'auth_service.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  final SettingsController settingsController;
  const SignUpPage({Key? key, required this.settingsController})
      : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';
  String nom = '';
  String prenom = '';
  String role = 'user'; // Par défaut
  String telephone = '';
  String adresse = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    widget.settingsController.primaryColor.withOpacity(0.7),
                    Colors.grey[850]!
                  ]
                : [widget.settingsController.primaryColor, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Cercles décoratifs en arrière-plan
            Positioned(
              top: -100,
              left: -100,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? widget.settingsController.primaryColor
                        : widget.settingsController.primaryColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? widget.settingsController.primaryColor
                        : widget.settingsController.primaryColor,
                  ),
                ),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _animation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth > 600
                                  ? screenWidth / 3
                                  : screenWidth,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.black.withOpacity(0.7)
                                  : Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Inscription',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : widget.settingsController
                                                .primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Wrap(
                                      spacing: 20,
                                      runSpacing: 20,
                                      children: [
                                        // Champs de formulaire en deux colonnes
                                        SizedBox(
                                          width: screenWidth > 600
                                              ? constraints.maxWidth / 2 - 10
                                              : constraints.maxWidth,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Nom',
                                              labelStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              prefixIcon: Icon(Icons.person,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'Entrez votre nom'
                                                : null,
                                            onChanged: (value) =>
                                                setState(() => nom = value),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth > 600
                                              ? constraints.maxWidth / 2 - 10
                                              : constraints.maxWidth,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Prénom',
                                              labelStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              prefixIcon: Icon(Icons.person,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'Entrez votre prénom'
                                                : null,
                                            onChanged: (value) =>
                                                setState(() => prenom = value),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth > 600
                                              ? constraints.maxWidth / 2 - 10
                                              : constraints.maxWidth,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Adresse e-mail',
                                              labelStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              prefixIcon: Icon(Icons.email,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'Entrez une adresse e-mail'
                                                : null,
                                            onChanged: (value) =>
                                                setState(() => email = value),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth > 600
                                              ? constraints.maxWidth / 2 - 10
                                              : constraints.maxWidth,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Mot de passe',
                                              labelStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              prefixIcon: Icon(Icons.lock,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                            ),
                                            obscureText: true,
                                            validator: (value) => value!
                                                        .length <
                                                    6
                                                ? 'Entrez un mot de passe de 6 caractères ou plus'
                                                : null,
                                            onChanged: (value) => setState(
                                                () => password = value),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth > 600
                                              ? constraints.maxWidth / 2 - 10
                                              : constraints.maxWidth,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Confirmer le mot de passe',
                                              labelStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              prefixIcon: Icon(Icons.lock,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                            ),
                                            obscureText: true,
                                            validator: (value) => value !=
                                                    password
                                                ? 'Les mots de passe ne correspondent pas'
                                                : null,
                                            onChanged: (value) => setState(
                                                () => confirmPassword = value),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth > 600
                                              ? constraints.maxWidth / 2 - 10
                                              : constraints.maxWidth,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Téléphone',
                                              labelStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              prefixIcon: Icon(Icons.phone,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'Entrez votre numéro de téléphone'
                                                : null,
                                            onChanged: (value) => setState(
                                                () => telephone = value),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth > 600
                                              ? constraints.maxWidth / 2 - 10
                                              : constraints.maxWidth,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Adresse',
                                              labelStyle: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              prefixIcon: Icon(Icons.home,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : widget
                                                          .settingsController
                                                          .primaryColor),
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'Entrez votre adresse'
                                                : null,
                                            onChanged: (value) =>
                                                setState(() => adresse = value),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          var user = await _authService
                                              .registerWithEmailAndPassword(
                                                  email,
                                                  password,
                                                  nom,
                                                  prenom,
                                                  role,
                                                  telephone,
                                                  adresse);
                                          if (user != null) {
                                            Navigator.pushReplacementNamed(
                                                context, HomePage.routeName);
                                          } else {
                                            // Afficher un message d'erreur
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(double.infinity, 40),
                                        backgroundColor: isDarkMode
                                            ? widget
                                                .settingsController.primaryColor
                                                .withOpacity(0.7)
                                            : widget.settingsController
                                                .primaryColor,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Inscription',
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.white),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Retourner à la page de connexion
                                      },
                                      child: Text(
                                        'Vous avez déjà un compte ? Connexion',
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : widget.settingsController
                                                    .primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
