import 'dart:io';

import 'package:appimmo/src/comments/comments_model.dart';
import 'package:appimmo/src/favorite/favorite_model.dart';
import 'package:appimmo/src/property/property_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PropertyService {
  final DatabaseReference _propertiesRef =
      FirebaseDatabase.instance.ref('properties');

  //final DatabaseReference _favoritesRef = FirebaseDatabase.instance.ref('favorites');

  // Créer une propriété
  Future<void> createProperty(
      Property property, File? coverImage, List<File?> images) async {
    if (coverImage != null) {
      property.cover_url = await uploadImage(coverImage);
    }

    if (images.isNotEmpty) {
      for (var image in images) {
        if (image != null) {
          property.images.add(await uploadImage(image));
        }
      }
    }

    // Générer un ID unique pour le property
    final newpropertyId = _propertiesRef.push().key;

    // Enregistrer le property avec l'ID unique
    await _propertiesRef.child(newpropertyId!).set(property.toMap());

    // Mettre à jour l'ID du property dans l'objet property
    property.propertyId = newpropertyId;
  }

  // Récupérer une propriété par ID
  Future<Property?> getPropertyById(String propertyId) async {
    try {
      final snapshot = await _propertiesRef.child(propertyId).get();
      if (snapshot.exists) {
        return Property.fromMap(
            snapshot.value as Map<String, dynamic>, propertyId);
      }
      return null;
    } catch (e) {
      throw Exception("Erreur lors de la récupération de la propriété : $e");
    }
  }

  // Récupérer toutes les propriétés
  Future<List<Property>> getAllProperties() async {
    try {
      final snapshot = await _propertiesRef.get();
      if (snapshot.exists) {
        final properties = <Property>[];
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          properties.add(Property.fromMap(value as Map<String, dynamic>, key));
        });
        return properties;
      }
      return [];
    } catch (e) {
      throw Exception("Erreur lors de la récupération des propriétés : $e");
    }
  }

  // Mettre à jour une propriété
  Future<void> updateProperty(Property property) async {
    try {
      if (property.propertyId == null) {
        throw Exception("L'ID de la propriété est null");
      }
      await _propertiesRef.child(property.propertyId!).update(property.toMap());
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour de la propriété : $e");
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);
    Reference storageRef =
        FirebaseStorage.instance.ref('property_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Rechercher des propriétés
  Future<List<Property>> searchProperties(String query) async {
    try {
      final snapshot = await _propertiesRef
          .orderByChild('titre')
          .startAt(query)
          .endAt('$query\uf8ff')
          .get();

      if (snapshot.exists) {
        return snapshot.children.map((child) {
          return Property.fromMap(
              child.value as Map<String, dynamic>, child.key!);
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception("Erreur lors de la recherche des propriétés : $e");
    }
  }

  // Stream pour récupérer toutes les propriétés
  Stream<List> getAllPropertiesStream() {
    return _propertiesRef.onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value;
        if (data is Map<Object?, Object?>) {
          return data.entries.map((entry) {
            if (entry.value is Map<Object?, Object?>) {
              return Property.fromMap(
                Map<String, dynamic>.from(entry.value as Map<Object?, Object?>),
                entry.key as String,
              );
            } else {
              throw Exception('Invalid property data format');
            }
          }).toList();
        } else {
          throw Exception('Expected a Map but got ${data.runtimeType}');
        }
      }
      return [];
    });
  }

  Future<void> deleteProperty(String propertyId) async {
    // Récupérer les informations du Property avant de le supprimer
    Property? property = await getPropertyById(propertyId);
    if (property != null) {
      // Supprimer l'image de couverture si elle existe
      if (property.cover_url.isNotEmpty) {
        await _deleteFileFromStorage(property.cover_url);
      }

      // Supprimer toutes les images associées au Property
      for (var imageUrl in property.images) {
        if (imageUrl.isNotEmpty) {
          await _deleteFileFromStorage(imageUrl);
        }
      }

      // Supprimer tous les commentaires associés au Property
      await _deleteComments(propertyId);

      // Supprimer le Property de la base de données
      await _propertiesRef.child(propertyId).remove();
    }
  }

// Fonction pour supprimer un fichier de Firebase Storage
  Future<void> _deleteFileFromStorage(String fileUrl) async {
    try {
      // Convertir l'URL en référence Firebase Storage
      Reference fileRef = FirebaseStorage.instance.refFromURL(fileUrl);
      await fileRef.delete();
    } catch (e) {
      print("Erreur lors de la suppression du fichier : $e");
    }
  }

// Fonction pour supprimer les commentaires associés à un Property
  Future<void> _deleteComments(String propertyId) async {
    final commentsRef = _propertiesRef.child(propertyId).child('comments');
    await commentsRef.remove();
  }

  Future<void> addComment(String propertyId, Comment comment) async {
    final commentId =
        _propertiesRef.child(propertyId).child('comments').push().key;
    await _propertiesRef
        .child(propertyId)
        .child('comments')
        .child(commentId!)
        .set(comment.toJson());
  }

  Future<void> likeProperty(String propertyId, String userId) async {
    final propertyRef = _propertiesRef.child(propertyId);
    final propertySnapshot = await propertyRef.once();

    if (propertySnapshot.snapshot.value != null) {
      final propertyData = Map<String, dynamic>.from(
          propertySnapshot.snapshot.value as Map<Object?, Object?>);

      // Récupérer la liste des likes
      List<dynamic> likes =
          propertyData['likes'] is List ? List.from(propertyData['likes']) : [];

      // Ajouter l'utilisateur à la liste des likes s'il n'est pas déjà présent
      if (!likes.contains(userId)) {
        likes.add(userId);
        await propertyRef.update({'likes': likes});
      }
    }
  }

  Future<void> unlikeProperty(String propertyId, String userId) async {
    final propertyRef = _propertiesRef.child(propertyId);
    final propertySnapshot = await propertyRef.once();

    if (propertySnapshot.snapshot.value != null) {
      final propertyData = Map<String, dynamic>.from(
          propertySnapshot.snapshot.value as Map<Object?, Object?>);

      // Récupérer la liste des likes
      List<dynamic> likes =
          propertyData['likes'] is List ? List.from(propertyData['likes']) : [];

      // Retirer l'utilisateur de la liste des likes s'il est présent
      if (likes.contains(userId)) {
        likes.remove(userId);
        await propertyRef.update({'likes': likes});
      }
    }
  }

  Future<List<Comment>> fetchComments(String propertyId) async {
    final commentsRef = _propertiesRef.child(propertyId).child('comments');
    final commentsSnapshot = await commentsRef.once();

    if (commentsSnapshot.snapshot.value != null) {
      final commentsData = commentsSnapshot.snapshot.value;
      if (commentsData is Map<Object?, Object?>) {
        return commentsData.entries.map((entry) {
          if (entry.value is Map<Object?, Object?>) {
            return Comment.fromJson(
              Map<String, dynamic>.from(entry.value as Map<Object?, Object?>),
              entry.key as String,
            );
          } else {
            throw Exception('Invalid comment data format');
          }
        }).toList();
      } else {
        throw Exception('Expected a Map but got ${commentsData.runtimeType}');
      }
    }
    return [];
  }

  Future<void> deleteComment(String propertyId, String commentId) async {
    await _propertiesRef
        .child(propertyId)
        .child('comments')
        .child(commentId)
        .remove();
  }

  Future<int> countLikes(String propertyId) async {
    final propertyRef = _propertiesRef.child(propertyId);
    final propertySnapshot = await propertyRef.once();

    if (propertySnapshot.snapshot.value != null) {
      final propertyData = Map<String, dynamic>.from(
          propertySnapshot.snapshot.value as Map<Object?, Object?>);

      // Récupérer la liste des likes
      List<dynamic> likes =
          propertyData['likes'] is List ? propertyData['likes'] : [];

      // Retourner le nombre de likes
      return likes.length;
    }
    return 0; // Si aucun like n'existe
  }

  Future<int> countComments(String propertyId) async {
    final commentsRef = _propertiesRef.child(propertyId).child('comments');
    final commentsSnapshot = await commentsRef.once();

    if (commentsSnapshot.snapshot.value != null) {
      final commentsData = Map<String, dynamic>.from(
          commentsSnapshot.snapshot.value as Map<Object?, Object?>);

      // Retourner le nombre de commentaires
      return commentsData.length;
    }
    return 0; // Si aucun commentaire n'existe
  }
/* 
  Future<void> addFavorite(String userId, String propertyId) async {
    final favoriteId = _favoritesRef.push().key;
    await _favoritesRef.child(favoriteId!).set(Favorite(
          userId: userId,
          propertyId: propertyId,
        ).toMap());
  }

  Future<void> removeFavorite(String userId, String propertyId) async {
    final favoriteRef = _favoritesRef.child(userId).child(propertyId);
    await favoriteRef.remove();
  }

  Future<bool> isPropertyInFavorites(String userId, String propertyId) async {
    final favoriteRef = _favoritesRef.child(userId).child(propertyId);
    final favoriteSnapshot = await favoriteRef.once();
    return favoriteSnapshot.snapshot.value != null;
  } */

  Future<void> addFavorite(String userId, String propertyId) async {
    final propertyRef = _propertiesRef.child(propertyId);
    final propertySnapshot = await propertyRef.once();

    if (propertySnapshot.snapshot.value != null) {
      final propertyData = Map<String, dynamic>.from(
          propertySnapshot.snapshot.value as Map<Object?, Object?>);

      // Récupérer la liste des favoris
      List<dynamic> favorites = propertyData['favorites'] is List
          ? List.from(propertyData['favorites'])
          : [];

      // Ajouter l'utilisateur à la liste des favoris s'il n'est pas déjà présent
      if (!favorites.contains(userId)) {
        favorites.add(userId);
        await propertyRef.update({'favorites': favorites});
      }
    }
  }

  Future<void> removeFavorite(String userId, String propertyId) async {
    final propertyRef = _propertiesRef.child(propertyId);
    final propertySnapshot = await propertyRef.once();

    if (propertySnapshot.snapshot.value != null) {
      final propertyData = Map<String, dynamic>.from(
          propertySnapshot.snapshot.value as Map<Object?, Object?>);

      // Récupérer la liste des favoris
      List<dynamic> favorites = propertyData['favorites'] is List
          ? List.from(propertyData['favorites'])
          : [];

      // Retirer l'utilisateur de la liste des favoris s'il est présent
      if (favorites.contains(userId)) {
        favorites.remove(userId);
        await propertyRef.update({'favorites': favorites});
      }
    }
  }

  Future<List<Property>> getFavoriteProperties(String userId) async {
    final snapshot = await _propertiesRef.get();

    if (snapshot.exists) {
      final properties = <Property>[];
      final data = snapshot.value as Map<Object?, Object?>;

      data.forEach((key, value) {
        if (value is Map) {
          final propertyData = Map<String, dynamic>.from(value);
          if (propertyData['favorites'] is List &&
              propertyData['favorites'].contains(userId)) {
            properties.add(Property.fromMap(propertyData, key as String));
          }
        }
      });
      return properties;
    }
    return [];
  }

  Future<void> updateFeatured(String propertyId, bool isFeatured) async {
    await _propertiesRef.child(propertyId).update({'isFeatured': isFeatured});
  }

  Future<List<Property>> getFeaturedProperties() async {
    final snapshot = await _propertiesRef.orderByChild('date_ajout').get();

    if (snapshot.exists) {
      final properties = <Property>[];
      final data = snapshot.value as Map<Object?, Object?>;

      data.forEach((key, value) {
        // Assurez-vous que 'value' est un Map avant d'utiliser l'opérateur '[]'
        if (value is Map) {
          if (value['isFeatured'] == true) {
            properties.add(Property.fromMap(
              Map<String, dynamic>.from(value),
              key as String,
            ));
          }
        }
      });
      return properties;
    }
    return [];
  }
}
