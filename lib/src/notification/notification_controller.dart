import 'notification_service.dart';
import 'notification_model.dart';

class NotificationController {
  final NotificationService _notificationService = NotificationService();

  Future<void> createNotification(Notification notification) async {
    await _notificationService.createNotification(notification);
  }

  Future<Notification?> getNotification(String notificationId) async {
    return await _notificationService.getNotificationById(notificationId);
  }

  Future<void> updateNotification(
      String notificationId, Map<String, dynamic> updates) async {
    await _notificationService.updateNotification(notificationId, updates);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _notificationService.deleteNotification(notificationId);
  }
}
