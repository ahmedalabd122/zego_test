import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_chat_room/firebase_options.dart';
import 'package:zego_chat_room/main.dart';
import 'package:zego_chat_room/models/user_model.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, UserModel?>((ref) {
  return AuthViewModel();
});

class AuthViewModel extends StateNotifier<UserModel?> {
  static final _auth = FirebaseAuth.instance;
  static final _store = FirebaseFirestore.instance;

  AuthViewModel() : super(null);

  UserModel? _currentUser;
  UserModel get currentUser {
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    return _currentUser!;
  }

  static Future<void> setupFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<bool> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      showMyDialog();

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final UserModel user = UserModel(
        email: email,
        username: username,
        id: cred.user!.uid,
      );

      if (cred.user != null) {
        final docRef = _store.collection('users').doc(cred.user!.uid);
        final doc = await docRef.get();
        if (doc.exists) {
          Navigator.pop(navigatorKey.currentContext!);
          return false;
        }

        await docRef.set(user.toJson());
        Navigator.pop(navigatorKey.currentContext!);

        return true;
      }
      Navigator.pop(navigatorKey.currentContext!);

      return false;
    } catch (e) {
      debugPrint(e.toString());
      Navigator.pop(navigatorKey.currentContext!);

      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      showMyDialog();
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        final doc = await _store.collection('users').doc(cred.user!.uid).get();
        final data = doc.data();
        if (data != null) {
          _currentUser = UserModel.fromJson(data);
          state = _currentUser;
          Navigator.pop(navigatorKey.currentContext!);
          return true;
        }
      }
      Navigator.pop(navigatorKey.currentContext!);

      return false;
    } catch (e) {
      debugPrint(e.toString());
      Navigator.pop(navigatorKey.currentContext!);

      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get buildViews =>
      _store.collection('users').snapshots();
}

void showMyDialog() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
