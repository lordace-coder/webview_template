import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? phoneNumber;
  String? password;
  final SharedPreferences pref;

  AuthProvider(this.pref) {
    phoneNumber = pref.getString('phone');
    password = pref.getString('password');
  }
  
}
