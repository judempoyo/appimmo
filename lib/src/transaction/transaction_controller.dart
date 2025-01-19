import 'transaction_service.dart';
import 'transaction_model.dart';

class TransactionController {
  final TransactionService _transactionService = TransactionService();

  Future<void> createTransaction(Transactions transaction) async {
    await _transactionService.createTransaction(transaction);
  }

  Future<Transactions?> getTransaction(String transactionId) async {
    return await _transactionService.getTransactionById(transactionId);
  }

  Future<void> updateTransaction(
      String transactionId, Map<String, dynamic> updates) async {
    await _transactionService.updateTransaction(transactionId, updates);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactionService.deleteTransaction(transactionId);
  }
}
