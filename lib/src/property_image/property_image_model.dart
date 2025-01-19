class PropertyImage {
  String? imageId;
  String propertyId;
  String urlImage;
  DateTime dateAjout;

  PropertyImage({
    this.imageId,
    required this.propertyId,
    required this.urlImage,
    DateTime? dateAjout,
  }) : dateAjout = dateAjout ?? DateTime.now();

  // Convertir un objet PropertyImage en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'property_id': propertyId,
      'url_image': urlImage,
      'date_ajout': dateAjout.toIso8601String(),
    };
  }

  // Créer un objet PropertyImage à partir d'un Map de Firebase
  factory PropertyImage.fromMap(Map<String, dynamic> map, String imageId) {
    return PropertyImage(
      imageId: imageId,
      propertyId: map['property_id'],
      urlImage: map['url_image'],
      dateAjout: DateTime.parse(map['date_ajout']),
    );
  }
}
