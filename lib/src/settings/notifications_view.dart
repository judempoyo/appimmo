import 'package:appimmo/src/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  static const routeName = '/notifications';
  final SettingsController settingsController;

  const NotificationsView({super.key, required this.settingsController});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: settingsController.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(notifications[index]);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Notification notification) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              notification.icon,
              size: 40,
              color: settingsController.primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              notification.time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modèle de notification
class Notification {
  final String title;
  final String message;
  final String time;
  final IconData icon;

  Notification({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });
}

// Liste de notifications fictives
final List<Notification> notifications = [
  Notification(
    title: 'Nouvelle mise à jour disponible',
    message: 'Téléchargez la dernière version de l\'application.',
    time: 'Il y a 2 minutes',
    icon: Icons.update,
  ),
  Notification(
    title: 'Rappel de rendez-vous',
    message: 'Vous avez un rendez-vous demain à 10h.',
    time: 'Il y a 1 heure',
    icon: Icons.calendar_today,
  ),
  Notification(
    title: 'Message de l\'équipe',
    message: 'N\'oubliez pas de soumettre votre rapport.',
    time: 'Il y a 3 heures',
    icon: Icons.message,
  ),
  Notification(
    title: 'Nouvelle fonctionnalité ajoutée',
    message: 'Découvrez notre nouvelle fonctionnalité dans l\'application.',
    time: 'Hier',
    icon: Icons.new_releases,
  ),
  Notification(
    title: 'Alerte de sécurité',
    message: 'Votre mot de passe a été changé avec succès.',
    time: 'Hier',
    icon: Icons.security,
  ),
];
