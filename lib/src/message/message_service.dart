import 'package:firebase_database/firebase_database.dart';
import 'message_model.dart';

class MessageService {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref('messages');

  // Créer un message
  Future<void> createMessage(Message message) async {
    final messageRef = _messagesRef.push();
    message.messageId = messageRef.key;
    await messageRef.set(message.toMap());
  }

  // Récupérer un message par ID
  Future<Message?> getMessageById(String messageId) async {
    final snapshot = await _messagesRef.child(messageId).get();
    if (snapshot.exists) {
      return Message.fromMap(snapshot.value as Map<String, dynamic>, messageId);
    }
    return null;
  }

  // Mettre à jour un message
  Future<void> updateMessage(
      String messageId, Map<String, dynamic> updates) async {
    await _messagesRef.child(messageId).update(updates);
  }

  // Supprimer un message
  Future<void> deleteMessage(String messageId) async {
    await _messagesRef.child(messageId).remove();
  }
}
