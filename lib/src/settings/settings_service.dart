import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Constantes pour les clés de préférences partagées
const String _themeMode = 'theme_mode';
const String _primaryColor = 'primary_color';
const String _accentColor = 'accent_color';
const String _fontSize = 'font_size';
const String _fontFamily = 'font_family';
const String _reduceAnimations = 'reduce_animations';
const String _notificationMode = 'notification_mode';

class SettingsService {
  // Fonction pour charger les paramètres au démarrage
  Future<void> initializeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    //clearSharedPreferences();

    // Vérifiez si les préférences sont déjà définies
    if (!prefs.containsKey(_themeMode)) {
      await prefs.setString(_themeMode, 'system'); // Valeur par défaut
    }
    if (!prefs.containsKey(_primaryColor)) {
      await prefs.setInt(
          _primaryColor, Colors.teal.value); // Couleur principale par défaut
    }
    if (!prefs.containsKey(_accentColor)) {
      await prefs.setInt(
          _accentColor, Colors.grey.value); // Couleur d'accentuation par défaut
    }
    if (!prefs.containsKey(_fontSize)) {
      await prefs.setDouble(_fontSize, 14.0); // Taille de police par défaut
    }
    if (!prefs.containsKey(_fontFamily)) {
      await prefs.setString(_fontFamily, 'Roboto'); // Police par défaut
    }
    if (!prefs.containsKey(_reduceAnimations)) {
      await prefs.setBool(
          _reduceAnimations, false); // Réduction des animations par défaut
    }
    if (!prefs.containsKey(_notificationMode)) {
      await prefs.setString(
          _notificationMode, 'email'); // Mode de notification par défaut
    }

    // Afficher les valeurs des paramètres
    print('Paramètres initiaux :');
    print('Mode de thème : ${await themeMode()}');
    print('Couleur principale : ${await primaryColor()}');
    print('Couleur d\'accentuation : ${await accentColor()}');
    print('Taille de police : ${await fontSize()}');
    print('Police : ${await fontFamily()}');
    print('Réduction des animations : ${await reduceAnimations()}');
    print('Mode de notification : ${await notificationMode()}');
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Supprime toutes les données
  }

  // Fonction pour charger le mode de thème
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_themeMode) ?? 'system';
    return mode == 'dark'
        ? ThemeMode.dark
        : (mode == 'light' ? ThemeMode.light : ThemeMode.system);
  }

  // Fonction pour persister le mode de thème
  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    String mode = theme == ThemeMode.dark
        ? 'dark'
        : (theme == ThemeMode.light ? 'light' : 'system');
    await prefs.setString(_themeMode, mode);
  }

  // Fonction pour charger la couleur principale
  Future<Color> primaryColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue =
        prefs.getInt(_primaryColor) ?? Colors.teal.value; // Valeur par défaut
    return Color(colorValue);
  }

  // Fonction pour persister la couleur principale
  Future<void> updatePrimaryColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_primaryColor, color.value);
  }

  // Fonction pour charger la couleur d'accentuation
  Future<Color> accentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue =
        prefs.getInt(_accentColor) ?? Colors.grey.value; // Valeur par défaut
    return Color(colorValue);
  }

  // Fonction pour persister la couleur d'accentuation
  Future<void> updateAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColor, color.value);
  }

  // Fonction pour charger la taille de police
  Future<double> fontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final fontSize = prefs.getDouble(_fontSize);
    return fontSize?.toDouble() ?? 14.0; // Taille de police par défaut
  }

  // Fonction pour persister la taille de police
  Future<void> updateFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSize, size.toDouble());
  }

  // Fonction pour charger la police
  Future<String> fontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fontFamily) ?? 'Roboto'; // Police par défaut
  }

  // Fonction pour persister la police
  Future<void> updateFontFamily(String family) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamily, family);
  }

  // Fonction pour charger la réduction des animations
  Future<bool> reduceAnimations() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reduceAnimations) ??
        false; // Réduction des animations par défaut
  }

  // Fonction pour persister la réduction des animations
  Future<void> updateReduceAnimations(bool reduce) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reduceAnimations, reduce);
  }

  // Fonction pour charger le mode de notification
  Future<String> notificationMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_notificationMode) ??
        'email'; // Mode de notification par défaut
  }

  // Fonction pour persister le mode de notification
  Future<void> updateNotificationMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationMode, mode);
  }
}
