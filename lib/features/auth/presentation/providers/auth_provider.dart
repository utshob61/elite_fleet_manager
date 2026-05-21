import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth? _auth;
  User? _user;
  bool _isMockMode = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initialize();
  }

  void _initialize() {
    try {
      _auth = FirebaseAuth.instance;
      _auth!.authStateChanges().listen((User? user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Auth initialization failed, entering mock mode: $e");
      _isMockMode = true;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (_isMockMode) {
      // Mock login for demo purposes
      _user = null; // We can't easily mock User object, but we can set a flag
      // Let's use a simpler way for mock: just set a fake state
      debugPrint("Mock login successful");
      _user = null; 
      // Instead of relying on User, let's add a boolean for mock auth
      _isAuthenticatedMock = true;
      notifyListeners();
      return;
    }

    try {
      await _auth!.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  bool _isAuthenticatedMock = false;
  bool get isAuth => _isMockMode ? _isAuthenticatedMock : isAuthenticated;

  Future<void> signUpWithEmail(String email, String password) async {
    if (_isMockMode) {
      _isAuthenticatedMock = true;
      notifyListeners();
      return;
    }
    try {
      await _auth!.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (_isMockMode) {
      _isAuthenticatedMock = false;
      notifyListeners();
      return;
    }
    await _auth?.signOut();
  }
}
