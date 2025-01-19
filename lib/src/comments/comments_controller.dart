import 'package:appimmo/src/comments/comments_model.dart';
import 'package:appimmo/src/comments/comments_service.dart';

class CommentController {
  final CommentService _commentService = CommentService();

  Future<void> createComment(Comment comment) async {
    await _commentService.createComment(comment);
  }

  Future<Comment?> getComment(String commentId) async {
    return await _commentService.getComment(commentId);
  }

  Future<void> updateComment(Comment comment) async {
    await _commentService.updateComment(comment);
  }

  Future<void> deleteComment(String commentId) async {
    await _commentService.deleteComment(commentId);
  }
}
