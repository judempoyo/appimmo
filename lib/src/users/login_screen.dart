import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appimmo/src/admin/admin_home_screen.dart';
import 'package:appimmo/src/home/home_view.dart';
import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:appimmo/src/users/registration_screen.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  final SettingsController settingsController;
  const LoginPage({Key? key, required this.settingsController})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  String? _errorMessage;

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        var user =
            await _authService.signInWithEmailAndPassword(email, password);
        if (user != null) {
          if (user.uid == '5OrtbVvkl1YcO9sDFhI59CciL4G2') {
            Navigator.pushReplacementNamed(context, AdminPage.routeName);
          } else {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
        } else {
          setState(() {
            _errorMessage = 'Mot de passe ou email incorrect';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Une erreur s\'est produite. Veuillez reessayer.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.settingsController.primaryColor.withOpacity(0.7),
              widget.settingsController.accentColor
            ],
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth > 600
                                  ? constraints.maxWidth / 3
                                  : constraints.maxWidth,
                            ),
                            child: Container(
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
                                        'Connexion',
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
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Adresse e-mail',
                                          labelStyle: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white70
                                                  : widget.settingsController
                                                      .primaryColor),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          prefixIcon: Icon(Icons.email,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : widget.settingsController
                                                      .primaryColor),
                                        ),
                                        validator: (value) => value!.isEmpty
                                            ? 'Entrez une adresse e-mail'
                                            : null,
                                        onChanged: (value) =>
                                            setState(() => email = value),
                                      ),
                                      SizedBox(height: 20),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Mot de passe',
                                          labelStyle: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white70
                                                  : widget.settingsController
                                                      .primaryColor),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          prefixIcon: Icon(Icons.lock,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : widget.settingsController
                                                      .primaryColor),
                                        ),
                                        obscureText: true,
                                        validator: (value) => value!.length < 6
                                            ? 'Entrez un mot de passe de 6 caractères ou plus'
                                            : null,
                                        onChanged: (value) =>
                                            setState(() => password = value),
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              Size(double.infinity, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Connexion',
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text('Ou se connecter avec ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black)),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            icon: FaIcon(
                                                FontAwesomeIcons
                                                    .squareGooglePlus,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : widget.settingsController
                                                        .primaryColor),
                                            onPressed: () async {
                                              var user = await _authService
                                                  .signInWithGoogle();
                                              if (user != null) {
                                                Navigator.pushNamed(context,
                                                    HomePage.routeName);
                                              } else {
                                                setState(() {
                                                  _errorMessage =
                                                      'impossible de se connecter avec google';
                                                });
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: FaIcon(
                                                FontAwesomeIcons.userSecret,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : widget.settingsController
                                                        .primaryColor),
                                            onPressed: () async {
                                              var user = await _authService
                                                  .signInAnonymously();
                                              if (user != null) {
                                                Navigator.pushNamed(context,
                                                    HomePage.routeName);
                                              } else {
                                                setState(() {
                                                  _errorMessage =
                                                      'Impossible de se connecter anonymement';
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, SignUpPage.routeName);
                                        },
                                        child: Text(
                                          'Vous n\'avez pas un compte ? Inscrivez-vous',
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
