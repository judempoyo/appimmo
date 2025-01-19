import 'review_service.dart';
import 'review_model.dart';

class ReviewController {
  final ReviewService _reviewService = ReviewService();

  Future<void> createReview(Review review) async {
    await _reviewService.createReview(review);
  }

  Future<Review?> getReview(String reviewId) async {
    return await _reviewService.getReviewById(reviewId);
  }

  Future<void> updateReview(
      String reviewId, Map<String, dynamic> updates) async {
    await _reviewService.updateReview(reviewId, updates);
  }

  Future<void> deleteReview(String reviewId) async {
    await _reviewService.deleteReview(reviewId);
  }
}
