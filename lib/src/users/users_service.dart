import 'package:appimmo/src/users/users_model.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  // Créer un utilisateur
  Future<void> createUser(User user) async {
    try {
      final userRef = _usersRef.push();
      user.userId = userRef.key;
      await userRef.set(user.toMap());
    } catch (e) {
      throw Exception("Erreur lors de la création de l'utilisateur : $e");
    }
  }

  // Récupérer un utilisateur par ID
  Future<User?> getUserById(String userId) async {
    try {
      final snapshot = await _usersRef.child(userId).get();
      if (snapshot.exists) {
        return User.fromMap(snapshot.value as Map<String, dynamic>, userId);
      }
      return null;
    } catch (e) {
      throw Exception("Erreur lors de la récupération de l'utilisateur : $e");
    }
  }

  // Récupérer tous les utilisateurs
  Future<List<User>> getAllUsers() async {
    try {
      final snapshot = await _usersRef.get();
      if (snapshot.exists) {
        final users = <User>[];
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          users.add(User.fromMap(value as Map<String, dynamic>, key));
        });
        return users;
      }
      return [];
    } catch (e) {
      throw Exception("Erreur lors de la récupération des utilisateurs : $e");
    }
  }

  // Asynchronous method to fetch all agents
  Future<List<User>> getAllAgents() async {
    try {
      // Fetch data from Firebase asynchronously
      final DataSnapshot dataSnapshot = await _usersRef.get();

      if (dataSnapshot.exists) {
        final data = dataSnapshot.value as Map<dynamic, dynamic>;
        final agents = <User>[];

        // Convert Firebase data to User objects
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            // Safely cast the value to Map<String, dynamic>
            final userData =
                Map<String, dynamic>.from(value as Map<Object?, Object?>);
            if (userData['role'] == 'agent') {
              // Filter for agents only
              agents.add(User.fromMap(userData, key as String));
            }
          }
        });

        return agents;
      } else {
        return []; // Return an empty list if no data is found
      }
    } catch (e) {
      // Handle errors (e.g., log the error or return an empty list)
      print('Erreur lors de la récupération des agents: $e');
      return [];
    }
  }

  // Stream pour récupérer tous les agents
  Stream<List<User>> getAllAgentsStream() {
    return _usersRef.onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value;
        if (data is Map<Object?, Object?>) {
          return data.entries.map((entry) {
            if (entry.value is Map<Object?, Object?>) {
              return User.fromMap(
                Map<String, dynamic>.from(entry.value as Map<Object?, Object?>),
                entry.key as String,
              );
            } else {
              throw Exception('Invalid user data format');
            }
          }).toList();
        } else {
          throw Exception('Expected a Map but got ${data.runtimeType}');
        }
      }
      return [];
    });
  }
  // Mettre à jour un utilisateur

  Future<void> updateUser(User user) async {
    try {
      if (user.userId == null) {
        throw Exception("L'ID de l'utilisateur est null");
      }
      await _usersRef.child(user.userId!).update(user.toMap());
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour de l'utilisateur : $e");
    }
  }

  // Mettre à jour un utilisateur par son ID
  Future<void> updateUserById(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _usersRef.child(userId).update(updates);
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour de l'utilisateur : $e");
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      await _usersRef.child(userId).remove();
    } catch (e) {
      throw Exception("Erreur lors de la suppression de l'utilisateur : $e");
    }
  }
}
