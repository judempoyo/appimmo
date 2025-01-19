class Favorite {
  String? favoriteId;
  String userId;
  String propertyId;
  DateTime dateAjout;

  Favorite({
    this.favoriteId,
    required this.userId,
    required this.propertyId,
    DateTime? dateAjout,
  }) : dateAjout = dateAjout ?? DateTime.now();

  // Convertir un objet Favorite en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'property_id': propertyId,
      'date_ajout': dateAjout.toIso8601String(),
    };
  }

  // Créer un objet Favorite à partir d'un Map de Firebase
  factory Favorite.fromMap(Map<String, dynamic> map, String favoriteId) {
    return Favorite(
      favoriteId: favoriteId,
      userId: map['user_id'],
      propertyId: map['property_id'],
      dateAjout: DateTime.parse(map['date_ajout']),
    );
  }
}
