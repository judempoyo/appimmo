import 'package:flutter/material.dart';
import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService) {
    //loadSettings(); // Charger les paramètres au démarrage
  }

  final SettingsService _settingsService;

  // Propriétés privées pour stocker les paramètres
  late ThemeMode _themeMode;
  late Color _primaryColor;
  late Color _accentColor;
  late double _fontSize;
  late String _fontFamily;
  late bool _reduceAnimations;
  late String _notificationMode;

  // Getters pour accéder aux paramètres
  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  Color get accentColor => _accentColor;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  bool get reduceAnimations => _reduceAnimations;
  String get notificationMode => _notificationMode;

  /// Charge les paramètres de l'utilisateur depuis le SettingsService.
  Future<void> loadSettings() async {
    _settingsService.initializeSettings();
    try {
      _themeMode = await _settingsService.themeMode();
      _primaryColor = await _settingsService.primaryColor();
      _accentColor = await _settingsService.accentColor();
      _fontSize = await _settingsService.fontSize();
      _fontFamily = await _settingsService.fontFamily();
      _reduceAnimations = await _settingsService.reduceAnimations();
      _notificationMode = await _settingsService.notificationMode();

      notifyListeners(); // Notifier les écouteurs que les paramètres ont changé
    } catch (e) {
      debugPrint("Erreur lors du chargement des paramètres : $e");
    }
  }

  /// Met à jour et persiste le ThemeMode en fonction de la sélection de l'utilisateur.
  Future<void> updateThemeMode(ThemeMode newThemeMode) async {
    if (_themeMode != newThemeMode) {
      _themeMode = newThemeMode;
      await _settingsService.updateThemeMode(newThemeMode);
      notifyListeners(); // Notifier les écouteurs
    }
  }

  /// Met à jour et persiste la couleur principale.
  Future<void> updatePrimaryColor(Color newColor) async {
    if (_primaryColor != newColor) {
      _primaryColor = newColor;
      await _settingsService.updatePrimaryColor(newColor);
      notifyListeners(); // Notifier les écouteurs
    }
  }

  /// Met à jour et persiste la couleur d'accentuation.
  Future<void> updateAccentColor(Color newColor) async {
    if (_accentColor != newColor) {
      _accentColor = newColor;
      await _settingsService.updateAccentColor(newColor);
      notifyListeners(); // Notifier les écouteurs
    }
  }

  /// Met à jour et persiste la taille de la police.
  Future<void> updateFontSize(double newSize) async {
    if (_fontSize != newSize) {
      _fontSize = newSize;
      await _settingsService.updateFontSize(newSize);
      notifyListeners(); // Notifier les écouteurs
    }
  }

  /// Met à jour et persiste la famille de police.
  Future<void> updateFontFamily(String newFamily) async {
    if (_fontFamily != newFamily) {
      _fontFamily = newFamily;
      await _settingsService.updateFontFamily(newFamily);
      notifyListeners(); // Notifier les écouteurs
    }
  }

  /// Met à jour et persiste la réduction des animations.
  Future<void> updateReduceAnimations(bool reduce) async {
    if (_reduceAnimations != reduce) {
      _reduceAnimations = reduce;
      await _settingsService.updateReduceAnimations(reduce);
      notifyListeners(); // Notifier les écouteurs
    }
  }

  /// Met à jour et persiste le mode de notification.
  Future<void> updateNotificationMode(String mode) async {
    if (_notificationMode != mode) {
      _notificationMode = mode;
      await _settingsService.updateNotificationMode(mode);
      notifyListeners(); // Notifier les écouteurs
    }
  }
}
