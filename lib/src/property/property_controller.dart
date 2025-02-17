import 'dart:io';

import 'package:appimmo/src/property/property_model.dart';
import 'package:appimmo/src/property/property_service.dart';
import 'package:appimmo/src/comments/comments_model.dart';

class PropertyController {
  final PropertyService _propertyService = PropertyService();

  // Créer une propriété
  Future<void> createProperty(
      Property property, File? imageFile, List<File?> images) async {
    await _propertyService.createProperty(property, imageFile, images);
  }

  // Récupérer une propriété par ID
  Future<Property?> getPropertyById(String propertyId) async {
    return await _propertyService.getPropertyById(propertyId);
  }

  // Récupérer toutes les propriétés
  Future<List<Property>> getAllProperties() async {
    return await _propertyService.getAllProperties();
  }

  // Mettre à jour une propriété
  Future<void> updateProperty(Property property) async {
    await _propertyService.updateProperty(property);
  }

  // Supprimer une propriété
  Future<void> deleteProperty(String propertyId) async {
    await _propertyService.deleteProperty(propertyId);
  }

  // Rechercher des propriétés
  Future<List<Property>> searchProperties(String query) async {
    return await _propertyService.searchProperties(query);
  }

  // Stream pour récupérer toutes les propriétés
  Stream<List> getAllPropertiesStream() {
    return _propertyService
        .getAllPropertiesStream()
        .asBroadcastStream(); // Convert to broadcast stream
  }

  // Ajouter un commentaire à une propriété
  Future<void> addComment(String propertyId, Comment comment) async {
    await _propertyService.addComment(propertyId, comment);
  }

  // Récupérer les commentaires d'une propriété
  Future<List<Comment>> fetchComments(String propertyId) async {
    return await _propertyService.fetchComments(propertyId);
  }

  // Supprimer un commentaire
  Future<void> deleteComment(String propertyId, String commentId) async {
    await _propertyService.deleteComment(propertyId, commentId);
  }

  // Liké une propriété
  Future<void> likeProperty(String propertyId, String userId) async {
    await _propertyService.likeProperty(propertyId, userId);
  }

  // Unliké une propriété
  Future<void> unlikeProperty(String propertyId, String userId) async {
    await _propertyService.unlikeProperty(propertyId, userId);
  }

  // Compter le nombre de likes d'une propriété
  Future<int> countLikes(String propertyId) async {
    return await _propertyService.countLikes(propertyId);
  }

  // Compter le nombre de commentaires d'une propriété
  Future<int> countComments(String propertyId) async {
    return await _propertyService.countComments(propertyId);
  }

  // Ajouter une propriété aux favoris
  Future<void> addFavorite(String userId, String propertyId) async {
    await _propertyService.addFavorite(userId, propertyId);
  }

  Future<void> removeFavorite(String userId, String propertyId) async {
    await _propertyService.removeFavorite(userId, propertyId);
  }

  Future<List<Property>> getFavoriteProperties(String userId) async {
    return await _propertyService.getFavoriteProperties(userId);
  }

// Mettre à jour une propriété en vedette
  Future<void> updateFeatured(String propertyId, bool isFeatured) async {
    await _propertyService.updateFeatured(propertyId, isFeatured);
  }

  /* Future<bool> isPropertyInFavorites(String userId, String propertyId) async {
    return await _propertyService.isPropertyInFavorites(userId, propertyId);
  }
 */
// Récupérer les propriétés en vedette
  Future<List<Property>> getFeaturedProperties() async {
    return await _propertyService.getFeaturedProperties();
  }

  Future<String> uploadImage(File imageFile) async {
    return await _propertyService.uploadImage(imageFile);
  }

  Future<List<Property>> getSimilarProperties(Property currentProperty,
      {int limit = 5}) async {
    return await _propertyService.getSimilarProperties(currentProperty,
        limit: limit);
  }
}
