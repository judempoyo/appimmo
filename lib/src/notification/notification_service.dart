import 'package:firebase_database/firebase_database.dart';
import 'notification_model.dart';

class NotificationService {
  final DatabaseReference _notificationsRef =
      FirebaseDatabase.instance.ref('notifications');

  // Créer une notification
  Future<void> createNotification(Notification notification) async {
    final notificationRef = _notificationsRef.push();
    notification.notificationId = notificationRef.key;
    await notificationRef.set(notification.toMap());
  }

  // Récupérer une notification par ID
  Future<Notification?> getNotificationById(String notificationId) async {
    final snapshot = await _notificationsRef.child(notificationId).get();
    if (snapshot.exists) {
      return Notification.fromMap(
          snapshot.value as Map<String, dynamic>, notificationId);
    }
    return null;
  }

  // Mettre à jour une notification
  Future<void> updateNotification(
      String notificationId, Map<String, dynamic> updates) async {
    await _notificationsRef.child(notificationId).update(updates);
  }

  // Supprimer une notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsRef.child(notificationId).remove();
  }
}
