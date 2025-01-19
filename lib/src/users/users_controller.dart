import 'package:appimmo/src/users/users_model.dart';
import 'package:appimmo/src/users/users_service.dart';

class UserController {
  final UserService _userService = UserService();

  // Créer un utilisateur
  Future<void> createUser(User user) async {
    await _userService.createUser(user);
  }

  // Récupérer un utilisateur par ID
  Future<User?> getUser(String userId) async {
    return await _userService.getUserById(userId);
  }

  // Synchronous method to fetch all agents
  Future<List<User>> getAllAgentsSync() {
    return _userService.getAllAgents();
  }

  // Stream pour récupérer tous les agents
  Stream<List<User>> getAllAgents() {
    return _userService.getAllAgentsStream().asBroadcastStream();
  }

  // Récupérer tous les utilisateurs
  Future<List<User>> getAllUsers() async {
    return await _userService.getAllUsers();
  }

  // Mettre à jour un utilisateur
  Future<void> updateUser(User user) async {
    await _userService.updateUser(user);
  }

// Mettre à jour un utilisateur par son ID
  Future<void> updateUserById(
      String userId, Map<String, dynamic> updates) async {
    await _userService.updateUserById(userId, updates);
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    await _userService.deleteUser(userId);
  }
}
