import 'package:appimmo/src/users/users_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'users_model.dart' as UserModel; // Import your User model

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child('users');
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> createUser(UserModel.User user) async {
    try {
      await UserService().createUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email,
      String password,
      String avatar,
      String nom,
      String prenom,
      String role,
      String telephone,
      String adresse) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        UserModel.User newUser = UserModel.User(
          userId: user.uid,
          nom: nom,
          prenom: prenom,
          email: email,
          motDePasse: password, // À hasher avant de stocker
          role: role,
          telephone: telephone,
          adresse: adresse,
          dateInscription: DateTime.now(), avatar: avatar,
        );
        await _db.child(user.uid).set(newUser.toMap());
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Save additional user data in the Realtime Database if needed
      if (user != null) {
        UserModel.User newUser = UserModel.User(
            userId: user.uid,
            nom: user.displayName?.split(' ')[0] ??
                'Sans nom', // Use first name from Google
            prenom: user.displayName?.split(' ')[1] ??
                'Sans prénom', // Use last name from Google
            email: user.email!,
            motDePasse: '', // You might want to handle this differently
            role: 'user', // Default role
            telephone: '', // You might want to handle this differently
            adresse: '', // You might want to handle this differently
            dateInscription: DateTime.now(),
            avatar: '');
        await _db.child(user.uid).set(newUser.toMap());
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
