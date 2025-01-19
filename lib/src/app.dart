import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome
import 'package:appimmo/src/admin/admin_home_screen.dart';
import 'package:appimmo/src/home/home_view.dart';
import 'package:appimmo/src/settings/about_view.dart';
import 'package:appimmo/src/settings/notifications_view.dart';
import 'package:appimmo/src/users/login_screen.dart';
import 'package:appimmo/src/users/registration_screen.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: settingsController.loadSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Erreur de chargement des paramètres'));
        } else {
          return ListenableBuilder(
            listenable: settingsController,
            builder: (BuildContext context, Widget? child) {
              return MaterialApp(
                restorationScopeId: 'app',
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''), // French, no country code
                ],
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(context)!.appTitle,
                theme: ThemeData(
                  primaryColor: settingsController.primaryColor,
                  hintColor: settingsController.accentColor,
                  fontFamily: settingsController.fontFamily,
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(fontSize: settingsController.fontSize),
                    bodyMedium:
                        TextStyle(fontSize: settingsController.fontSize),
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                    size: 24.0,
                  ),
                  progressIndicatorTheme: ProgressIndicatorThemeData(
                    circularTrackColor:
                        settingsController.primaryColor.withAlpha(50),
                    color: settingsController.primaryColor,
                  ),
                  sliderTheme: SliderThemeData(
                    activeTrackColor: settingsController
                        .primaryColor, // Couleur de la piste active
                    inactiveTrackColor: settingsController.primaryColor
                        .withOpacity(0.3), // Couleur de la piste inactive
                    thumbColor:
                        settingsController.primaryColor, // Couleur du curseur
                    overlayColor: settingsController.primaryColor
                        .withOpacity(0.2), // Couleur de l'overlay du curseur
                    valueIndicatorColor: settingsController
                        .primaryColor, // Couleur de l'indicateur de valeur
                    activeTickMarkColor:
                        Colors.white, // Couleur des marques actives
                    inactiveTickMarkColor:
                        Colors.grey, // Couleur des marques inactives
                    trackHeight: 4.0, // Hauteur de la piste
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 10.0), // Forme du curseur
                    overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 20.0), // Forme de l'overlay
                    valueIndicatorShape:
                        PaddleSliderValueIndicatorShape(), // Forme de l'indicateur de valeur
                    showValueIndicator: ShowValueIndicator
                        .always, // Toujours afficher l'indicateur de valeur
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle:
                        TextStyle(color: settingsController.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: settingsController.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: settingsController.primaryColor),
                    ),
                    hintStyle: TextStyle(color: settingsController.accentColor),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: settingsController
                          .primaryColor, // Couleur du texte du bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  pageTransitionsTheme: settingsController.reduceAnimations
                      ? PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android:
                                NoAnimationPageTransitionsBuilder(),
                            TargetPlatform.iOS:
                                NoAnimationPageTransitionsBuilder(),
                          },
                        )
                      : null,
                  tabBarTheme: TabBarTheme(
                    indicatorColor: settingsController.primaryColor,
                    labelColor: settingsController.primaryColor,
                    overlayColor: WidgetStatePropertyAll(
                        settingsController.primaryColor.withAlpha(50)),
                  ),
                ),
                darkTheme: ThemeData.dark().copyWith(
                  primaryColor: settingsController.primaryColor,
                  hintColor: settingsController.accentColor,
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(fontSize: settingsController.fontSize),
                    bodyMedium:
                        TextStyle(fontSize: settingsController.fontSize),
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                    size: 24.0,
                  ),
                  progressIndicatorTheme: ProgressIndicatorThemeData(
                    circularTrackColor:
                        settingsController.primaryColor.withAlpha(50),
                    color: settingsController.primaryColor,
                  ),
                  sliderTheme: SliderThemeData(
                    activeTrackColor: settingsController
                        .primaryColor, // Couleur de la piste active
                    inactiveTrackColor: settingsController.primaryColor
                        .withOpacity(0.3), // Couleur de la piste inactive
                    thumbColor:
                        settingsController.primaryColor, // Couleur du curseur
                    overlayColor: settingsController.primaryColor
                        .withOpacity(0.2), // Couleur de l'overlay du curseur
                    valueIndicatorColor: settingsController
                        .primaryColor, // Couleur de l'indicateur de valeur
                    activeTickMarkColor:
                        Colors.white, // Couleur des marques actives
                    inactiveTickMarkColor:
                        Colors.grey, // Couleur des marques inactives
                    trackHeight: 4.0, // Hauteur de la piste
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 10.0), // Forme du curseur
                    overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 20.0), // Forme de l'overlay
                    valueIndicatorShape:
                        PaddleSliderValueIndicatorShape(), // Forme de l'indicateur de valeur
                    showValueIndicator: ShowValueIndicator
                        .always, // Toujours afficher l'indicateur de valeur
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle:
                        TextStyle(color: settingsController.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: settingsController.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: settingsController.primaryColor),
                    ),
                    hintStyle: TextStyle(color: settingsController.accentColor),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: settingsController.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  pageTransitionsTheme: settingsController.reduceAnimations
                      ? PageTransitionsTheme(
                          builders: {
                            TargetPlatform.android:
                                NoAnimationPageTransitionsBuilder(),
                            TargetPlatform.iOS:
                                NoAnimationPageTransitionsBuilder(),
                          },
                        )
                      : null,
                  tabBarTheme: TabBarTheme(
                    indicatorColor: settingsController.primaryColor,
                    labelColor: settingsController.primaryColor,
                    overlayColor: WidgetStatePropertyAll(
                        settingsController.primaryColor.withAlpha(50)),
                  ),
                ),
                themeMode: settingsController.themeMode,
                home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      User? user = snapshot.data;
                      if (user != null) {
                        // User is signed in, show HomeView
                        if (user.uid == '5OrtbVvkl1YcO9sDFhI59CciL4G2') {
                          return AdminPage(
                            settingsController: settingsController,
                          );
                        } else {
                          return HomePage(
                              settingsController: settingsController);
                        }
                      } else {
                        // User is not signed in, show LoginPage
                        return LoginPage(
                          settingsController: settingsController,
                        );
                      }
                    } else {
                      // While loading, show a loading indicator
                      return SplashScreen();
                    }
                  },
                ),
                onGenerateRoute: (RouteSettings routeSettings) {
                  return MaterialPageRoute<void>(
                    settings: routeSettings,
                    builder: (BuildContext context) {
                      switch (routeSettings.name) {
                        case SettingsView.routeName:
                          return SettingsView(controller: settingsController);
                        case AboutUsPage.routeName:
                          return AboutUsPage(
                            settingsController: settingsController,
                          );
                        case NotificationsView.routeName:
                          return NotificationsView(
                            settingsController: settingsController,
                          );
                        case HomePage.routeName:
                          return HomePage(
                            settingsController: settingsController,
                          );
                        case AdminPage.routeName:
                          return AdminPage(
                            settingsController: settingsController,
                          );
                        case SignUpPage.routeName:
                          return SignUpPage(
                            settingsController: settingsController,
                          );
                        default:
                          return LoginPage(
                            settingsController: settingsController,
                          ); // Fallback to LoginPage
                      }
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child; // Pas d'animation, juste le widget enfant
  }
}

/// Écran de démarrage pour masquer le temps de chargement.
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo ou image
            Image.asset(
              'assets/images/logo.png', // Remplacez par le chemin de votre image
              width: 100, // Ajustez la taille selon vos besoins
              height: 100,
            ),
            const SizedBox(height: 20), // Espacement entre l'image et le texte
            Text(
              'Bienvenue dans notre application',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height: 10), // Espacement entre le titre et le sous-titre
            Text(
              'Votre compagnon idéal pour explorer le monde',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height: 30), // Espacement avant l'indicateur de chargement
            CircularProgressIndicator(), // Indicateur de chargement
          ],
        ),
      ),
    );
  }
}

// Méthode utilitaire pour créer des icônes FontAwesome avec des styles par défaut
Widget defaultFontAwesomeIcon(BuildContext context, IconData icon,
    {double size = 24.0, Color? color}) {
  return FaIcon(
    icon,
    size: size,
    color: color ?? Theme.of(context).iconTheme.color,
  );
}
