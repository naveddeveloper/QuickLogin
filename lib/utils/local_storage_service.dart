import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _uidKey = "uid";
  static const String _emailKey = "email";

  // Save user data from the local storage
  static Future<void> saveUserData(String uid, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_uidKey, uid);
      await prefs.setString(_emailKey, email);
    } catch (e) {
      debugPrint("Error $e :: saveUserData() LocalStorageService");
    }
  }

  // Delete the user data from the local storage
  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_uidKey);
      await prefs.remove(_emailKey);
    } catch (e) {
      debugPrint("Error $e :: clearUserData() LocalStorageService");
    }
  }

  // Check if the user exists in local storage
  static Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_uidKey);
    } catch (e) {
      debugPrint("Error $e :: isUserLoggedIn() LocalStorageService");
      return false;
    }
  }

  // Get the user data in local storage
  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'uid': prefs.getString(_uidKey)!,
      'email': prefs.getString(_emailKey)!,
    };
  }
}
