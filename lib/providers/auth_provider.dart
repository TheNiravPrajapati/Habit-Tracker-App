import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;

  Future<String?> signUp(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // Create Firestore user profile
      await _db.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "created_at": Timestamp.now(),
      });

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final uid = _auth.currentUser!.uid;
      final ref = _db.collection("users").doc(uid);
      final doc = await ref.get();

      // Ensure profile exists
      if (!doc.exists) {
        await ref.set({
          "name": "User",
          "email": email,
          "created_at": Timestamp.now(),
        });
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


  Future<Map<String, dynamic>?> loadProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final ref = _db.collection("users").doc(uid);
    final doc = await ref.get();

    // If profile does not exist, create a default one
    if (!doc.exists) {
      await ref.set({
        "name": "New User",
        "email": _auth.currentUser!.email,
        "created_at": Timestamp.now(),
      });

      return {
        "name": "New User",
        "email": _auth.currentUser!.email,
      };
    }

    return doc.data();
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<String?> updateProfile(String name, String email) async {
    final user = _auth.currentUser;
    if (user == null) return "Not logged in";

    try {
      await user.updateDisplayName(name);
      await user.verifyBeforeUpdateEmail(email);

      await _db.collection("users").doc(user.uid).update({
        "name": name,
        "email": email,
      });

      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }


}
