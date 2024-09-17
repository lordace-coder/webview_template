import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:charles_click/models/app_lock_provider.dart';
import 'package:charles_click/models/webview_provider.dart';
import 'package:charles_click/pages/home_pagev2.dart';
import 'package:charles_click/pages/sign_up_2.dart';
import 'package:charles_click/services/notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final authProvider = AuthProvider(pref);
  // for notifications
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        defaultRingtoneType: DefaultRingtoneType.Notification,
      )
    ],
  );

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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _lifecycleObserver = AppLifecycleObserver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charles Clicks VTU',
      debugShowCheckedModeBanner: false,
      home: AppLock(
        backgroundLockLatency: const Duration(seconds: 15),
        builder: (context, obj) {
          return HomePagev2();
        },
        lockScreenBuilder: (c) {
          return SignIn2();
        },
      ),
    );
  }
}
