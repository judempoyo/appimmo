import 'package:firebase_auth/firebase_auth.dart';
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

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(),
                  _FormContent(
                    settingsController: widget.settingsController,
                  ),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(
                          child: _FormContent(
                        settingsController: widget.settingsController,
                      )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Bienvenu sur APPIMMO!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  final SettingsController settingsController;

  const _FormContent({Key? key, required this.settingsController})
      : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

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
          if (e is FirebaseAuthException) {
            if (e.code == 'user-not-found') {
              _errorMessage = 'Utilisateur non trouvé';
            } else if (e.code == 'wrong-password') {
              _errorMessage = 'Mot de passe incorrect';
            } else if (e.code == 'user-disabled') {
              _errorMessage = 'Utilisateur désactivé';
            } else {
              _errorMessage = 'Une erreur s\'est produite. Veuillez reessayer.';
            }
          } else {
            _errorMessage = 'Une erreur s\'est produite. Veuillez reessayer.';
          }
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez une adresse e-mail';
                  }

                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) {
                    return 'Entrez une adresse e-mail valide';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  hintText: 'Entrez votre adresse e-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => email = value),
              ),
              _gap(),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un mot de passe';
                  }

                  if (value.length < 6) {
                    return 'Le mot de passe doit avoir au moins 6 caractères';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Entrez votre mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )),
                onChanged: (value) => setState(() => password = value),
              ),
              _gap(),
              CheckboxListTile(
                value: _rememberMe,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _rememberMe = value;
                  });
                },
                title: const Text('Se souvenir de moi'),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: const EdgeInsets.all(0),
              ),
              _gap(),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              _gap(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Connexion',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: _submitForm,
                ),
              ),
              _gap(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpPage.routeName);
                },
                child: Text(
                  'pas de compte ? Inscrivez-vous',
                  style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : widget.settingsController.primaryColor),
                ),
              ),
              _gap(),
              Text(
                'Ou se connecter avec',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              _gap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      var user = await _authService.signInWithGoogle();
                      if (user != null) {
                        Navigator.pushNamed(context, HomePage.routeName);
                      } else {
                        setState(() {
                          _errorMessage =
                              'Impossible de se connecter avec Google';
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.userSecret,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      var user = await _authService.signInAnonymously();
                      if (user != null) {
                        Navigator.pushNamed(context, HomePage.routeName);
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
