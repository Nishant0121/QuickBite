import 'package:firebase_auth/firebase_auth.dart';
import 'package:qbite/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _userFromFirebase(User? user) {
    return user != null
        ? AppUser(
            uid: user.uid,
            email: user.email,
            name: user.displayName,
            photoUrl: user.photoURL,
          )
        : null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByUID(String uid) async {
    try {
      // Reference to the document with the specified UID
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Return the user data as a map
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print("User with UID $uid does not exist.");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      String profileUrl =
          "https://avatar.iran.liara.run/public?username=" + name;

      // Check if user creation was successful
      if (user != null) {
        // Add user to Firestore database
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': user.email,
          'photoUrl': profileUrl,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(), // Add a creation timestamp
          // Add other user fields if needed
        });
        return user;
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
