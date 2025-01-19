class Comment {
  String? commentId;
  String postId;
  String authorId;
  String authorEmail;
  String content;
  DateTime createdAt;

  Comment({
    required this.commentId,
    required this.postId,
    required this.authorId,
    required this.authorEmail,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json, String commentId) {
    return Comment(
      commentId: commentId,
      postId: json['post_id'],
      authorId: json['author_id'],
      authorEmail: json['author_email'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'author_id': authorId,
      'author_email': authorEmail,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
