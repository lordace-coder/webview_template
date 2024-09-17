import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:charles_click/pages/home_pagev2.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = Dio();

Future<bool> isAuthenticated({
  required String phone,
  required String password,
}) async {
  final formData = FormData.fromMap({
    'phone': phone,
    'password': password,
    'device': "200100200",
  });

  try {
    final response = await dio.post(
      'https://charlesclicksvtu.com/mobile/home/includes/route.php?login',
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    if (response.statusCode == 200) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('phone', phone);
      pref.setString('password', password);
      await saveCookiesAndLocalStorage(response);
      return true;
    }
  } catch (e) {
    print('Authentication error: $e');
  }
  return false;
}

Future<void> saveCookiesAndLocalStorage(Response response) async {
  final prefs = await SharedPreferences.getInstance();

  // Save cookies
  final cookies = response.headers['set-cookie'];
  if (cookies != null) {
    await prefs.setStringList('cookies', cookies);
  }

  // Save local storage data
  // Note: This assumes the server sends local storage data in the response body
  // You may need to adjust this based on how the server actually sends the data
  if (response.data is Map<String, dynamic>) {
    final localStorageData = response.data['localStorage'];
    if (localStorageData != null && localStorageData is Map<String, dynamic>) {
      for (var entry in localStorageData.entries) {
        await prefs.setString(
            'localStorage_${entry.key}', entry.value.toString());
      }
    }
  }
}

void navigateToWebViewPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => HomePagev2(),
    ),
  );
}
