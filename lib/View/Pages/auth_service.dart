// lib/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const String _userKey = 'user_data';
  static const String _isAuthenticatedKey = 'is_authenticated';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<bool> register(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user already exists
      final existingUsers = prefs.getStringList('users') ?? [];
      if (existingUsers.any((user) => jsonDecode(user)['email'] == email)) {
        throw Exception('User already exists');
      }

      // Create new user
      final user = {
        'name': name,
        'email': email,
        'password': password, // In real app, this should be hashed
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Add user to users list
      existingUsers.add(jsonEncode(user));
      await prefs.setStringList('users', existingUsers);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get users list
      final users = prefs.getStringList('users') ?? [];

      // Find user with matching credentials
      final userJson = users.firstWhere(
            (user) {
          final userData = jsonDecode(user);
          return userData['email'] == email && userData['password'] == password;
        },
        orElse: () => '',
      );

      if (userJson.isEmpty) {
        throw Exception('Invalid credentials');
      }

      final userData = jsonDecode(userJson);

      // Store authenticated user data
      await prefs.setString(_userKey, userJson);
      await prefs.setBool(_isAuthenticatedKey, true);

      return userData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isAuthenticatedKey, false);
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return jsonDecode(userJson);
  }

  Future<bool> resetPassword(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = prefs.getStringList('users') ?? [];

      // Find user with matching email
      final userExists = users.any(
            (user) => jsonDecode(user)['email'] == email,
      );

      if (!userExists) {
        throw Exception('User not found');
      }

      // In a real app, you would send a reset email here
      // For now, we'll just return true if the email exists
      return true;
    } catch (e) {
      rethrow;
    }
  }
}