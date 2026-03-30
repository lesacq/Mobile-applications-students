import '../services/profile_service.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';


class AuthViewModel extends ChangeNotifier {
  String? _profileImageUrl;
  String? get profileImageUrl => _profileImageUrl;
  final ProfileService _profileService = ProfileService();
  bool _isInitializing = true;

  Future<void> uploadProfilePicture(File imageFile) async {
    _setLoading(true);
    _clearError();
    try {
      final url = await _profileService.uploadProfilePicture(imageFile);
      if (url != null) {
        _profileImageUrl = url;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  AuthViewModel() {
    // Listen to auth state changes
    _authService.user.listen((user) {
      _user = user;
      if (user == null) {
        _profileImageUrl = null;
      }
      _isInitializing = false;
      notifyListeners();
    });
  }

  bool get isInitializing => _isInitializing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final result = await _authService.signIn(email, password);
      _user = result;
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final result = await _authService.signUp(email, password);
      _user = result;
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _clearError();
    await _authService.signOut();
    _user = null;
    _profileImageUrl = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
