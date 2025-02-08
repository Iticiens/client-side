import 'dart:async';

import 'package:iot/generated/pocketbase/users_record.dart';
import 'package:iot/main.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message; // Add this to properly format the error message
}

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<UsersRecord?> getCurrentUser();
  Stream<bool> get authStateChanges;
  bool get isAuthenticated;
}

class AuthRepositoryImpl implements AuthRepository {
  final _authStateController = StreamController<bool>.broadcast();

  AuthRepositoryImpl() {
    // Initialize auth state
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      _authStateController.add(true);
    } catch (e) {
      throw AuthException('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    pb.authStore.clear();
    _authStateController.add(false);
  }

  @override
  Future<UsersRecord?> getCurrentUser() async {
    try {
      if (!pb.authStore.isValid) return null;
      final record = await pb
          .collection('users')
          .getOne(pb.authStore.model.id, expand: 'stations, client, drivers');
      return UsersRecord.fromRecordModel(record);
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  bool get isAuthenticated => pb.authStore.isValid;

  void dispose() {
    _authStateController.close();
  }
}
