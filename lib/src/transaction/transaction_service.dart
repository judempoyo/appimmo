import 'package:appimmo/src/transaction/transaction_model.dart';
import 'package:firebase_database/firebase_database.dart';

class TransactionService {
  final DatabaseReference _transactionsRef =
      FirebaseDatabase.instance.ref('transactions');

  // Créer une transaction
  Future<void> createTransaction(Transactions transaction) async {
    final transactionRef = _transactionsRef.push();
    transaction.transactionId = transactionRef.key;
    await transactionRef.set(transaction.toMap());
  }

  // Récupérer une transaction par ID
  Future<Transactions?> getTransactionById(String transactionId) async {
    final snapshot = await _transactionsRef.child(transactionId).get();
    if (snapshot.exists) {
      return Transactions.fromMap(
          snapshot.value as Map<String, dynamic>, transactionId);
    }
    return null;
  }

  // Mettre à jour une transaction
  Future<void> updateTransaction(
      String transactionId, Map<String, dynamic> updates) async {
    await _transactionsRef.child(transactionId).update(updates);
  }

  // Supprimer une transaction
  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsRef.child(transactionId).remove();
  }
}
