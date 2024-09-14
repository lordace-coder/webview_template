import 'package:charles_click/models/webview_provider.dart';
import 'package:charles_click/pages/home_pagev2.dart';
import 'package:charles_click/pages/landing_page.dart';
import 'package:charles_click/pages/sign_up_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WebViewProgressProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppLock(
        builder: (context, obj) {
          return HomePagev2();
        },
        lockScreenBuilder: (c) {
          // check if a user can use biometrics
          // check if a users save data is available
          // if a user can't use biometrics lead him to the [SignIn2] else [SIgnInPage]
          return SignIn2();
        },
      ),
    );
  }
}
