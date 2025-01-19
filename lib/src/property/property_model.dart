import 'package:appimmo/src/comments/comments_model.dart';

class Property {
  String? propertyId;
  String titre;
  String description;
  String type;
  double prix;
  double surface;
  int nombrePieces;
  String adresse;
  String ville;
  String codePostal;
  String pays;
  bool disponible;
  DateTime dateAjout;
  String agentId;
  List<String> likes;
  List<Comment> comments;
  List<String> images;
  List<String> favorites;
  String cover_url;
  bool isFeatured = false;

  Property(
      {this.propertyId,
      required this.titre,
      required this.description,
      required this.type,
      required this.prix,
      required this.surface,
      required this.nombrePieces,
      required this.adresse,
      required this.ville,
      required this.codePostal,
      required this.pays,
      required this.disponible,
      DateTime? dateAjout,
      required this.agentId,
      this.likes = const [],
      this.comments = const [],
      this.images = const [],
      this.favorites = const [],
      required this.cover_url,
      this.isFeatured = false})
      : dateAjout = dateAjout ?? DateTime.now();

  // Convertir un objet Property en Map pour Firebase
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'type': type,
      'prix': prix,
      'surface': surface,
      'nombre_pieces': nombrePieces,
      'adresse': adresse,
      'ville': ville,
      'code_postal': codePostal,
      'pays': pays,
      'disponible': disponible,
      'date_ajout': dateAjout.toIso8601String(),
      'agent_id': agentId,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'images': images,
      'favorites': favorites,
      'cover_url': cover_url,
      'isFeatured': isFeatured,
    };
  }

  // Créer un objet Property à partir d'un Map de Firebase
  factory Property.fromMap(Map<String, dynamic> map, String propertyId) {
    return Property(
      propertyId: propertyId,
      titre: map['titre'],
      description: map['description'],
      type: map['type'],
      prix: map['prix'].toDouble(),
      surface: map['surface'].toDouble(),
      nombrePieces: map['nombre_pieces'],
      adresse: map['adresse'],
      ville: map['ville'],
      codePostal: map['code_postal'],
      pays: map['pays'],
      disponible: map['disponible'],
      dateAjout: DateTime.parse(map['date_ajout']),
      agentId: map['agent_id'],
      likes: List<String>.from(map['likes'] ?? []),
      comments:
          (map['comments'] as Map<Object?, Object?>?)?.entries.map((entry) {
                final commentId =
                    entry.key as String; // Convertir la clé en String
                final commentData = Map<String, dynamic>.from(entry.value as Map<
                    Object?,
                    Object?>); // Convertir la valeur en Map<String, dynamic>
                return Comment.fromJson(
                    commentData, commentId); // Passer les données converties
              }).toList() ??
              [],
      images: List<String>.from(map['images'] ?? []),
      favorites: List<String>.from(map['favorites'] ?? []),
      cover_url: map['cover_url'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
    );
  }
}
