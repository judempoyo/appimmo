import 'package:firebase_database/firebase_database.dart';
import 'review_model.dart';

class ReviewService {
  final DatabaseReference _reviewsRef =
      FirebaseDatabase.instance.ref('reviews');

  // Créer un avis
  Future<void> createReview(Review review) async {
    final reviewRef = _reviewsRef.push();
    review.reviewId = reviewRef.key;
    await reviewRef.set(review.toMap());
  }

  // Récupérer un avis par ID
  Future<Review?> getReviewById(String reviewId) async {
    final snapshot = await _reviewsRef.child(reviewId).get();
    if (snapshot.exists) {
      return Review.fromMap(snapshot.value as Map<String, dynamic>, reviewId);
    }
    return null;
  }

  // Mettre à jour un avis
  Future<void> updateReview(
      String reviewId, Map<String, dynamic> updates) async {
    await _reviewsRef.child(reviewId).update(updates);
  }

  // Supprimer un avis
  Future<void> deleteReview(String reviewId) async {
    await _reviewsRef.child(reviewId).remove();
  }
}
