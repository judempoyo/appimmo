import 'package:flutter/material.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  SettingsView({
    super.key,
    required this.controller,
  });

  static const routeName = '/settings';

  final SettingsController controller;

// Liste de couleurs principales modernes
  final List<Color> primaryColors = [
    Color(0xFFFF6F61), // Corail
    Color(0xFFB0BEC5), // Gris clair
    Color(0xFFB2DFDB), // Vert menthe
    Color(0xFF1A237E), // Bleu nuit
    Color(0xFFFFF176), // Jaune pastel
    Color(0xFFE1BEE7), // Lavande
    Color(0xFFAB47BC), // Mauve
    Color(0xFF0097A7), // Teal
    Color(0xFF4CAF50), // Vert lime
    Color(0xFF2196F3), // Bleu vif
    Color(0xFF8BC34A), // Vert clair
    Color(0xFFCDDC39), // Lime clair
    Color(0xFFFF9800), // Orange vif
    Color(0xFF795548), // Marron foncé
    Color(0xFF607D8B), // Bleu-gris foncé
  ];

// Liste de couleurs secondaires modernes
  final List<Color> accentColors = [
    Color(0xFFFF5252), // Corail vif
    Color(0xFFFFD740), // Or
    Color(0xFFE91E63), // Rose fuchsia
    Color(0xFFCDDC39), // Vert lime
    Color(0xFF81D4FA), // Bleu clair
    Color(0xFF455A64), // Gris foncé
    Color(0xFFFFA726), // Orange doux
    Color(0xFF03DAC5), // Teal clair
    Color(0xFF6200EE), // Violet foncé
    Color(0xFFBB86FC), // Violet clair
    Color(0xFF03A9F4), // Bleu azur
    Color(0xFF4CAF50), // Vert lime
    Color(0xFFFFC107), // Jaune citron
    Color(0xFFFF5722), // Orange vif
    Color(0xFF9C27B0), // Pourpre clair
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Apparence'),
          _buildListTile(
            context,
            title: 'Sélectionnez le thème',
            icon: Icons.color_lens,
            onTap: () {
              _showThemeDialog(context);
            },
          ),
          _buildListTile(
            context,
            title: 'Couleur principale',
            icon: Icons.palette,
            onTap: () {
              _showColorPickerDialog(controller.primaryColor, primaryColors,
                  controller.updatePrimaryColor, context);
            },
          ),
          _buildListTile(
            context,
            title: 'Couleur d\'accentuation',
            icon: Icons.colorize,
            onTap: () {
              _showColorPickerDialog(controller.accentColor, accentColors,
                  controller.updateAccentColor, context);
            },
          ),
          _buildSectionTitle('Texte'),
          _buildListTile(
            context,
            title: 'Taille de la police',
            icon: Icons.text_fields,
            onTap: () {
              _showFontSizeDialog(context);
            },
          ),
          _buildListTile(
            context,
            title: 'Police',
            icon: Icons.font_download,
            onTap: () {
              _showFontFamilyDialog(context);
            },
          ),
          _buildSectionTitle('Animations'),
          SwitchListTile(
            activeColor: Theme.of(context).primaryColor,
            title: const Text('Réduire les animations'),
            value: controller.reduceAnimations,
            onChanged: (bool value) {
              controller.updateReduceAnimations(value);
            },
          ),
          _buildSectionTitle('Notifications'),
          _buildListTile(
            context,
            title: 'Mode de notifications',
            icon: Icons.notifications,
            onTap: () {
              _showNotificationModeDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sélectionnez le thème'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Thème système'),
                onTap: () {
                  controller.updateThemeMode(ThemeMode.system);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Thème clair'),
                onTap: () {
                  controller.updateThemeMode(ThemeMode.light);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Thème sombre'),
                onTap: () {
                  controller.updateThemeMode(ThemeMode.dark);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPickerDialog(Color currentColor, List<Color> colors,
      ValueChanged<Color> onColorChanged, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisissez une couleur'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Afficher la couleur actuellement sélectionnée
                Container(
                  height: 50,
                  width: double.infinity,
                  color: currentColor,
                  child: const Center(
                      child: Text('Couleur actuelle',
                          style: TextStyle(color: Colors.white))),
                ),
                const SizedBox(height: 10),
                // Couleurs prédéfinies
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return _buildColorTile(colors[index], onColorChanged);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Choisir'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Widget pour afficher une tuile de couleur
  Widget _buildColorTile(Color color, ValueChanged<Color> onColorChanged) {
    return GestureDetector(
      onTap: () {
        onColorChanged(color);
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black54),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Taille de la police'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: controller.fontSize,
                min: 10,
                max: 30,
                divisions: 20,
                label: controller.fontSize.round().toString(),
                onChanged: (value) {
                  controller.updateFontSize(value);
                },
              ),
              Text(
                'Taille actuelle : ${controller.fontSize.round()}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFontFamilyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sélectionnez la police'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Roboto'),
                onTap: () {
                  controller.updateFontFamily('Roboto');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Arial'),
                onTap: () {
                  controller.updateFontFamily('Arial');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Times New Roman'),
                onTap: () {
                  controller.updateFontFamily('Times New Roman');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sélectionnez le mode de notifications'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Email'),
                onTap: () {
                  controller.updateNotificationMode('email');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('SMS'),
                onTap: () {
                  controller.updateNotificationMode('sms');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Push Notifications'),
                onTap: () {
                  controller.updateNotificationMode('push');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
