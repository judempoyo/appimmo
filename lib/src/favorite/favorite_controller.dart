import 'favorite_service.dart';
import 'favorite_model.dart';

class FavoriteController {
  final FavoriteService _favoriteService = FavoriteService();

  Future<void> createFavorite(Favorite favorite) async {
    await _favoriteService.createFavorite(favorite);
  }

  Future<Favorite?> getFavorite(String favoriteId) async {
    return await _favoriteService.getFavoriteById(favoriteId);
  }

  Future<void> updateFavorite(
      String favoriteId, Map<String, dynamic> updates) async {
    await _favoriteService.updateFavorite(favoriteId, updates);
  }

  Future<void> deleteFavorite(String favoriteId) async {
    await _favoriteService.deleteFavorite(favoriteId);
  }
}
