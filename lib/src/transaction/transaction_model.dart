class Transactions {
  String? transactionId;
  String contractId;
  double montant;
  DateTime dateTransaction;
  String statut;

  Transactions({
    this.transactionId,
    required this.contractId,
    required this.montant,
    DateTime? dateTransaction,
    required this.statut,
  }) : dateTransaction = dateTransaction ?? DateTime.now();

  // Convertir un objet Transaction en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'contract_id': contractId,
      'montant': montant,
      'date_transaction': dateTransaction.toIso8601String(),
      'statut': statut,
    };
  }

  // Créer un objet Transaction à partir d'un Map de Firebase
  factory Transactions.fromMap(Map<String, dynamic> map, String transactionId) {
    return Transactions(
      transactionId: transactionId,
      contractId: map['contract_id'],
      montant: map['montant'],
      dateTransaction: DateTime.parse(map['date_transaction']),
      statut: map['statut'],
    );
  }
}
