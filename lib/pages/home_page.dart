import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
// ···
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(Uri.parse('https://charlesclicksvtu.com/'));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // loading progress bar
            StatefulBuilder(builder: (context, rebuild) {
              controller.setNavigationDelegate(
                NavigationDelegate(onProgress: (prog) {
                  rebuild(() {
                    _progress = prog / 100;
                  });
                }),
              );
              return LinearProgressIndicator(
                value: _progress,
              );
            }),
            Expanded(
                child: WebViewWidget(
              controller: controller,
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
            ))
          ],
        ),
      ),
    );
  }
}
