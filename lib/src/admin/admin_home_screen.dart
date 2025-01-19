import 'package:flutter/material.dart';
import 'package:appimmo/src/admin/admin_base_screen.dart';
import 'package:appimmo/src/admin/dashboard.dart';
import 'package:appimmo/src/settings/settings_controller.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key, required this.settingsController})
      : super(key: key);
  static const routeName = '/adminpage';

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AdminBasePage(
      title: 'Tableau de bord', // Titre par défaut
      body: AdminPanel(
        settingsController: settingsController,
      ), // Corps par défaut
      settingsController: settingsController,
    );
  }
}
