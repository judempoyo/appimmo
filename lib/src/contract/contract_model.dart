class Contract {
  String? contractId;
  String propertyId;
  String clientId;
  String agentId;
  String typeContrat;
  DateTime dateDebut;
  DateTime dateFin;
  double montant;
  String statut;

  Contract({
    this.contractId,
    required this.propertyId,
    required this.clientId,
    required this.agentId,
    required this.typeContrat,
    required this.dateDebut,
    required this.dateFin,
    required this.montant,
    required this.statut,
  });

  // Convertir un objet Contract en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'property_id': propertyId,
      'client_id': clientId,
      'agent_id': agentId,
      'type_contrat': typeContrat,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin.toIso8601String(),
      'montant': montant,
      'statut': statut,
    };
  }

  // Créer un objet Contract à partir d'un Map de Firebase
  factory Contract.fromMap(Map<String, dynamic> map, String contractId) {
    return Contract(
      contractId: contractId,
      propertyId: map['property_id'],
      clientId: map['client_id'],
      agentId: map['agent_id'],
      typeContrat: map['type_contrat'],
      dateDebut: DateTime.parse(map['date_debut']),
      dateFin: DateTime.parse(map['date_fin']),
      montant: map['montant'],
      statut: map['statut'],
    );
  }
}
