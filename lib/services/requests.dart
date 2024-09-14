import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
    final request = await dio.post(
        'https://charlesclicksvtu.com/mobile/home/includes/route.php?login',
        data: formData);
    if (request.statusCode == 200) {
      return true;
    }
  } catch (e) {
    null;
  }
  return false;
}
