import 'package:appimmo/src/users/users_model.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  // Créer un utilisateur
  Future<void> createUser(User user) async {
    try {
      await _usersRef.child(user.userId!).set(user.toMap());
    } catch (e) {
      throw Exception("Erreur lors de la création de l'utilisateur : $e");
    }
  }

  // Récupérer un utilisateur par ID

  Future<User?> getUserById(String userId) async {
    try {
      final snapshot = await _usersRef.child(userId).get();
      if (snapshot.exists) {
        final userData =
            Map<String, dynamic>.from(snapshot.value as Map<Object?, Object?>);
        return User.fromMap(userData, userId);
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
        final data = snapshot.value as Map<Object?, Object?>;
        data.forEach((key, value) {
          if (key != null) {
            final userData =
                Map<String, dynamic>.from(value as Map<Object?, Object?>);
            users.add(User(
              userId: key as String,
              nom: userData['nom'] ?? '',
              prenom: userData['prenom'] ?? '',
              email: userData['email'] ?? '',
              motDePasse: userData['mot_de_passe'] ?? '',
              avatar: userData['avatar'] ?? '',
              role: userData['role'] ?? '',
              telephone: userData['telephone'] ?? '',
              adresse: userData['adresse'] ?? '',
              dateInscription:
                  DateTime.parse(userData['date_inscription'] ?? ''),
            ));
          }
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
      final DataSnapshot dataSnapshot = await _usersRef.get();

      if (dataSnapshot.exists) {
        final data = dataSnapshot.value as Map<dynamic, dynamic>;
        final agents = <User>[];

        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            final userData = Map<String, dynamic>.from(value);
            if (userData['role'] == 'agent' && key != null) {
              agents.add(User.fromMap(userData, key as String));
            }
          }
        });

        return agents;
      } else {
        return []; // Return an empty list if no data is found
      }
    } catch (e) {
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
