import 'package:flutter/material.dart';

class WebViewProgressProvider extends ChangeNotifier {
  double _progress = 0.0;
  bool _isLoading = false;

  double get progress => _progress;
  bool get isLoading => _isLoading;

  void updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    if (!loading) {
      // reset progress
      _progress = 0.0;
    }
    notifyListeners();
  }

  void reset() {
    _progress = 0.0;
    _isLoading = false;
    notifyListeners();
  }
}
