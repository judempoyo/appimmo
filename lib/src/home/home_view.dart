import 'package:flutter/material.dart';
import 'package:appimmo/src/home/base_screen.dart';
import 'package:appimmo/src/settings/settings_controller.dart';

class HomePage extends BasePage {
  const HomePage({
    Key? key,
    required SettingsController settingsController,
  }) : super(key: key, settingsController: settingsController);
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  @override
  List<Widget> get pages => [
        Center(child: Text('Page Accueil')),
        Center(child: Text('Liste des Appartements')),
        Center(child: Text('Liste des Maisons')),
        Center(child: Text('Liste des Bureaux')),
      ];
}
