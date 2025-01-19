class Review {
  String? reviewId;
  String propertyId;
  String userId;
  int note;
  String commentaire;
  DateTime dateAjout;

  Review({
    this.reviewId,
    required this.propertyId,
    required this.userId,
    required this.note,
    required this.commentaire,
    DateTime? dateAjout,
  }) : dateAjout = dateAjout ?? DateTime.now();

  // Convertir un objet Review en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'property_id': propertyId,
      'user_id': userId,
      'note': note,
      'commentaire': commentaire,
      'date_ajout': dateAjout.toIso8601String(),
    };
  }

  // Créer un objet Review à partir d'un Map de Firebase
  factory Review.fromMap(Map<String, dynamic> map, String reviewId) {
    return Review(
      reviewId: reviewId,
      propertyId: map['property_id'],
      userId: map['user_id'],
      note: map['note'],
      commentaire: map['commentaire'],
      dateAjout: DateTime.parse(map['date_ajout']),
    );
  }
}
