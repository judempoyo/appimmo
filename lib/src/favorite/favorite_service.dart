import 'package:firebase_database/firebase_database.dart';
import 'favorite_model.dart';

class FavoriteService {
  final DatabaseReference _favoritesRef =
      FirebaseDatabase.instance.ref('favorites');

  // Créer un favori
  Future<void> createFavorite(Favorite favorite) async {
    final favoriteRef = _favoritesRef.push();
    favorite.favoriteId = favoriteRef.key;
    await favoriteRef.set(favorite.toMap());
  }

  // Récupérer un favori par ID
  Future<Favorite?> getFavoriteById(String favoriteId) async {
    final snapshot = await _favoritesRef.child(favoriteId).get();
    if (snapshot.exists) {
      return Favorite.fromMap(
          snapshot.value as Map<String, dynamic>, favoriteId);
    }
    return null;
  }

  // Mettre à jour un favori
  Future<void> updateFavorite(
      String favoriteId, Map<String, dynamic> updates) async {
    await _favoritesRef.child(favoriteId).update(updates);
  }

  // Supprimer un favori
  Future<void> deleteFavorite(String favoriteId) async {
    await _favoritesRef.child(favoriteId).remove();
  }
}
