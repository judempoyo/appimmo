import 'package:flutter/material.dart';
import 'comments_service.dart'; // Import your CommentService
import 'comments_model.dart'; // Import your Comment model

class CommentsPage extends StatelessWidget {
  final String userId; // ID de l'utilisateur connecté

  CommentsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.teal;
    final commentService = CommentService(); // Initialize the CommentService

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Commentaires'),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<Comment>>(
        future: commentService
            .fetchCommentsByUser(userId), // Fetch comments by user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun commentaire trouvé.'));
          }

          final comments = snapshot.data!;

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(comment.content),
                  subtitle: Text('Author ID: ${comment.authorId}'),
                  trailing: comment.authorId == userId
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Bouton pour modifier le commentaire
                            IconButton(
                              icon: Icon(Icons.edit, color: primaryColor),
                              onPressed: () {
                                _showEditCommentDialog(
                                  context,
                                  commentService,
                                  comment.commentId!,
                                  comment.content,
                                );
                              },
                            ),
                            // Bouton pour supprimer le commentaire
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteCommentDialog(
                                  context,
                                  commentService,
                                  comment.commentId!,
                                );
                              },
                            ),
                          ],
                        )
                      : null, // Afficher les boutons uniquement si l'utilisateur est l'auteur du commentaire
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fonction pour afficher un dialogue de modification de commentaire
  void _showEditCommentDialog(
    BuildContext context,
    CommentService commentService,
    String commentId,
    String currentContent,
  ) {
    final TextEditingController _commentController =
        TextEditingController(text: currentContent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le commentaire'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Entrez votre commentaire'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final newContent = _commentController.text;
                if (newContent.isNotEmpty) {
                  await commentService.updateComment(
                    Comment(
                        commentId: commentId,
                        content: newContent,
                        createdAt: DateTime.now(),
                        authorId: userId,
                        authorEmail: userId,
                        postId: ''),
                  );
                  Navigator.of(context)
                      .pop(); // Rafraîchir la liste des commentaires après la mise à jour
                  (context as Element).markNeedsBuild();
                }
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher un dialogue de confirmation de suppression
  void _showDeleteCommentDialog(
    BuildContext context,
    CommentService commentService,
    String commentId,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Supprimer le commentaire'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce commentaire ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await commentService.deleteComment(commentId);
                Navigator.of(context).pop(); // Fermer le dialogue
                (context as Element)
                    .markNeedsBuild(); // Rafraîchir la liste des commentaires
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
