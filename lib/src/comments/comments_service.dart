import 'package:firebase_database/firebase_database.dart';
import 'package:appimmo/src/comments/comments_model.dart';

class CommentService {
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref().child('comments');

  Future<void> createComment(Comment comment) async {
    await _db.child(comment.commentId!).set(comment.toJson());
  }

  Future<Comment?> getComment(String commentId) async {
    DatabaseEvent event = await _db.child(commentId).once();
    if (event.snapshot.value != null) {
      return Comment.fromJson(
          Map<String, dynamic>.from(
              event.snapshot.value as Map<Object?, Object?>),
          commentId);
    }
    return null;
  }

  Future<List<Comment>> fetchComments(String postId) async {
    DatabaseEvent event =
        await _db.orderByChild('post_id').equalTo(postId).once();
    if (event.snapshot.value != null) {
      Map<Object?, Object?> data =
          event.snapshot.value as Map<Object?, Object?>;
      return data.entries
          .map((entry) => Comment.fromJson(
              Map<String, dynamic>.from(entry.value as Map<Object?, Object?>),
              entry.key as String))
          .toList();
    }
    return [];
  }

  Future<List<Comment>> fetchCommentsByUser(String authorId) async {
    DatabaseEvent event =
        await _db.orderByChild('authorId').equalTo(authorId).once();
    if (event.snapshot.value != null) {
      Map<Object?, Object?> data =
          event.snapshot.value as Map<Object?, Object?>;
      return data.entries.map((entry) {
        final commentId = entry.key as String;
        final commentData =
            Map<String, dynamic>.from(entry.value as Map<Object?, Object?>);
        return Comment.fromJson(commentData, commentId);
      }).toList();
    }
    return [];
  }

  Future<void> updateComment(Comment comment) async {
    await _db.child(comment.commentId!).update(comment.toJson());
  }

  Future<void> deleteComment(String commentId) async {
    await _db.child(commentId).remove();
  }
}
