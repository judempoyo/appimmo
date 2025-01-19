class Notification {
  String? notificationId;
  String userId;
  String message;

  Notification({
    this.notificationId,
    required this.userId,
    required this.message,
  });

  // Convertir un objet Notification en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'message': message,
    };
  }

  // Créer un objet Notification à partir d'un Map de Firebase
  factory Notification.fromMap(
      Map<String, dynamic> map, String notificationId) {
    return Notification(
      notificationId: notificationId,
      userId: map['user_id'],
      message: map['message'],
    );
  }
}
