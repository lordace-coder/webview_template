import 'package:flutter/material.dart';
import 'package:charles_click/services/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {
  String? phoneNumber;
  String? password;
  final SharedPreferences pref;

  AuthProvider(this.pref) {
    phoneNumber = pref.getString('phone');
    password = pref.getString('password');
  }

  Future<void> clearUserData() async {
    await pref.clear();
  }

  ///checks if the user is authenticated
  Future<bool> validateUser() async {
    // exits function if shared pref data is empty
    if (phoneNumber == null ||
        phoneNumber!.isEmpty ||
        password == null ||
        password!.isEmpty) return false;
    try {
      final isAuth =
          await isAuthenticated(phone: phoneNumber!, password: password!);
      return isAuth;
    } catch (e) {
      null;
    }
    return false;
  }

  // check if the user has data saved
  bool hasData() {
    return !(phoneNumber == null || password == null);
  }
}
