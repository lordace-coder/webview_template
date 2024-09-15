import 'package:charles_click/models/app_lock_provider.dart';
import 'package:charles_click/models/webview_provider.dart';
import 'package:charles_click/pages/home_pagev2.dart';
import 'package:charles_click/pages/sign_in_page.dart';
import 'package:charles_click/pages/sign_up_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final authProvider = AuthProvider(pref);
  final isAuth = await authProvider.validateUser();
  if (!isAuth) {
    await authProvider.clearUserData();
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebViewProgressProvider()),
        ChangeNotifierProvider(create: (_) => authProvider),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hasData = authProvider.hasData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppLock(
        builder: (context, obj) {
          return HomePagev2();
        },
        lockScreenBuilder: (c) {
          // return a diffrent page if a user has no data
          if (hasData) {
            return SignIn2();
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
