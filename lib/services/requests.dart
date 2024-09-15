import 'package:charles_click/pages/home_pagev2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView')),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final prefs = snapshot.data!;
          final cookies = prefs.getStringList('cookies') ?? [];

          return InAppWebView(
            initialUrlRequest:
                URLRequest(url: WebUri('https://charlesclicksvtu.com')),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) async {
              // Set cookies
              for (var cookie in cookies) {
                await CookieManager.instance().setCookie(
                  url: WebUri('https://charlesclicksvtu.com'),
                  name: cookie.split('=')[0],
                  value: cookie.split('=')[1].split(';')[0],
                );
              }

              // Set local storage
              prefs
                  .getKeys()
                  .where((key) => key.startsWith('localStorage_'))
                  .forEach((key) {
                final value = prefs.getString(key) ?? '';
                controller.evaluateJavascript(
                    source:
                        "localStorage.setItem('${key.substring(11)}', '$value');");
              });
            },
          );
        },
      ),
    );
  }
}
