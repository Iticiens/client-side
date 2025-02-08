import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iot/generated/pocketbase/users_record.dart';
import 'package:iot/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _error;
  UsersRecord? _currentUser;
  StreamSubscription? _authStateSubscription;

  AuthProvider(this._authRepository) {
    // Listen to auth state changes
    _authStateSubscription =
        _authRepository.authStateChanges.listen((isAuthenticated) {
      if (isAuthenticated) {
        _loadUserDetails(); // Reload user details when auth state changes to authenticated
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _authRepository.isAuthenticated;
  UsersRecord? get currentUser => _currentUser;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      await _loadUserDetails();
    } on AuthException catch (e) {
      _error = e.toString();
      _currentUser = null;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserDetails() async {
    try {
      _currentUser = await _authRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _currentUser = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
