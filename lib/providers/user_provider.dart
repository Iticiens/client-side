// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:iot/generated/pocketbase/users_record.dart';

import 'package:iot/repository/user_repository.dart';

class UserProvider extends ChangeNotifier {
  UserRepository _userRepository;
  UserProvider(
    this._userRepository,
  );

  bool _isLoading = false;
  String? _error;
  UsersRecord? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UsersRecord? get currentUser => _user;

  Future<void> getCurrentUserDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userRepository.getCurrentUserDetails();
    } catch (e) {
      _error = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
