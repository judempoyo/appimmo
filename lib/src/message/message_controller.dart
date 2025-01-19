import 'message_service.dart';
import 'message_model.dart';

class MessageController {
  final MessageService _messageService = MessageService();

  Future<void> createMessage(Message message) async {
    await _messageService.createMessage(message);
  }

  Future<Message?> getMessage(String messageId) async {
    return await _messageService.getMessageById(messageId);
  }

  Future<void> updateMessage(
      String messageId, Map<String, dynamic> updates) async {
    await _messageService.updateMessage(messageId, updates);
  }

  Future<void> deleteMessage(String messageId) async {
    await _messageService.deleteMessage(messageId);
  }
}
