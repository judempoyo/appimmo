class Message {
  String? messageId;
  String senderId;
  String receiverId;
  String propertyId;
  String contenu;
  DateTime dateEnvoi;
  bool lu;

  Message({
    this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.propertyId,
    required this.contenu,
    DateTime? dateEnvoi,
    this.lu = false,
  }) : dateEnvoi = dateEnvoi ?? DateTime.now();

  // Convertir un objet Message en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'property_id': propertyId,
      'contenu': contenu,
      'date_envoi': dateEnvoi.toIso8601String(),
      'lu': lu,
    };
  }

  // Créer un objet Message à partir d'un Map de Firebase
  factory Message.fromMap(Map<String, dynamic> map, String messageId) {
    return Message(
      messageId: messageId,
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      propertyId: map['property_id'],
      contenu: map['contenu'],
      dateEnvoi: DateTime.parse(map['date_envoi']),
      lu: map['lu'],
    );
  }
}
