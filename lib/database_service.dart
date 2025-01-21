import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DatabaseService {
  // Use environment variables or secure configuration management
  static const String _collectionName = "pdDetection";

  bool get isConnected => _db.isConnected;

  late Db _db;
  late DbCollection _collection;

  // Constructor that takes connection string as parameter
  DatabaseService();

  Future<void> connect({required String connectionString}) async {
    try {
      _db = await Db.create(connectionString);
      await _db.open();
      _collection = _db.collection(_collectionName);
      print("MongoDB connected successfully!");
    } catch (e) {
      throw DatabaseException('Error connecting to MongoDB: $e');
    }
  }

  Future<void> disconnect() async {
    if (_db.isConnected) {
      await _db.close();
    }
  }

  Future<List<Map<String, dynamic>>> getAllDocuments() async {
    _ensureConnected();
    return await _collection.find().toList();
  }

  Future<void> insertDocument(Map<String, dynamic> data) async {
    _ensureConnected();
    await _collection.insert(data);
  }

  Future<void> updateDocument(
      Map<String, dynamic> query, Map<String, dynamic> updates) async {
    _ensureConnected();
    await _collection.update(query, updates);
  }

  Future<void> deleteDocument(Map<String, dynamic> query) async {
    _ensureConnected();
    await _collection.remove(query);
  }

  Future<void> register(String name, String email, String password) async {
    _ensureConnected();
    try {
      // Validate inputs
      _validateEmail(email);
      _validatePassword(password);

      // Check if email already exists
      var existingUser = await _collection.findOne(where.eq('email', email));
      if (existingUser != null) {
        throw DatabaseException('Email is already registered');
      }

      // Hash password with salt
      final salt = _generateSalt();
      final hashedPassword = _hashPassword(password, salt);

      // Insert new user
      await _collection.insertOne({
        'name': name,
        'email': email.toLowerCase(),
        'password': hashedPassword,
        'salt': salt,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      throw DatabaseException('Failed to register user: $e');
    }
  }

  // Helper methods
  void _ensureConnected() {
    if (!isConnected) {
      throw DatabaseException('Database is not connected');
    }
  }

  String _generateSalt() {
    var random = List<int>.generate(32, (i) => DateTime.now().millisecondsSinceEpoch % 256);
    return base64.encode(random);
  }

  String _hashPassword(String password, String salt) {
    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw DatabaseException('Invalid email format');
    }
  }

  void _validatePassword(String password) {
    if (password.length < 8) {
      throw DatabaseException('Password must be at least 8 characters long');
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => message;
}