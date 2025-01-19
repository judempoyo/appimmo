class Visit {
  String? visitId;
  String propertyId;
  String clientId;
  String agentId;
  DateTime dateVisite;
  String statut;

  Visit({
    this.visitId,
    required this.propertyId,
    required this.clientId,
    required this.agentId,
    required this.dateVisite,
    required this.statut,
  });

  // Convertir un objet Visit en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'property_id': propertyId,
      'client_id': clientId,
      'agent_id': agentId,
      'date_visite': dateVisite.toIso8601String(),
      'statut': statut,
    };
  }

  // Créer un objet Visit à partir d'un Map de Firebase
  factory Visit.fromMap(Map<String, dynamic> map, String visitId) {
    return Visit(
      visitId: visitId,
      propertyId: map['property_id'],
      clientId: map['client_id'],
      agentId: map['agent_id'],
      dateVisite: DateTime.parse(map['date_visite']),
      statut: map['statut'],
    );
  }
}
