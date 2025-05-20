import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_data_model.dart';

class Storage {
  Future<void> saveUserToPreferences(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert User object to JSON
    final String userJson = jsonEncode(user.toJson());
    // Save JSON string to SharedPreferences
    print("userDataSave>>>>>${user.firstName}");
    await prefs.setString('user', userJson);
  }

  // Function to retrieve User object from SharedPreferences
  Future<User?> getUserFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');

    if (userJson != null) {
      // Parse JSON string to Map
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap); // Convert Map to User object
    }
    return null; // Return null if no user is saved
  }

  // Function to remove User object from SharedPreferences (if needed)
  Future<void> removeUserFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Remove user from SharedPreferences
  }

    Future<void> removeTokenFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove user from SharedPreferences
  }

  Future<void> saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedEmail', email);
    await prefs.setString('savedPassword', password);
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("Save Token => $token");

    await prefs.setString('token', token);
  }

  Future<void> setLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? language = prefs.getString('language');
    return language ?? "";
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    debugPrint("getToken => $token");

    return token ?? "";
  }

  // Function to retrieve saved email and password from SharedPreferences
  Future<Map<String, String?>> getSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('savedEmail');
    final String? password = prefs.getString('savedPassword');
    return {'email': email, 'password': password};
  }

  // Function to clear saved credentials from SharedPreferences (useful for logout)
  Future<void> clearCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedEmail');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('savedPassword');
  }

  Future<void> setFirstCardSkip(bool isSkip) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstCardSkip', isSkip);
  }

  Future<bool> getFirstCardSkip() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstCardSkip') ?? true;
  }

  Future<void> setIsIndivisual(bool isTrue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isIndivisual', isTrue);
  }

  Future<bool> getIsIndivisual() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isIndivisual') ?? true;
  }
}
