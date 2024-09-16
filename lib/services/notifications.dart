import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:async';

class AppLifecycleObserver extends WidgetsBindingObserver {
  DateTime? _pausedTime;
  Timer? _notificationTimer;
  static const _minimizedThreshold = Duration(seconds: 4);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
      _startNotificationTimer();
    } else if (state == AppLifecycleState.resumed) {
      _cancelNotificationTimer();
      _pausedTime = null;
    }
  }

  void _startNotificationTimer() {
    _notificationTimer = Timer(_minimizedThreshold, () {
      _sendNotification();
    });
  }

  void _cancelNotificationTimer() {
    _notificationTimer?.cancel();
    _notificationTimer = null;
  }

  Future<void> _sendNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        largeIcon: 'assets/mainlogo.png',
        title: 'Charles Clicks',
        body: 'Cheap and affordable data deals. click to purchase them now!!',
      ),
    );
  }
}
