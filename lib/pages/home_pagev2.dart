import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:charles_click/models/app_lock_provider.dart';
import 'package:charles_click/models/webview_provider.dart';
import 'package:charles_click/pages/error.dart';
import 'package:charles_click/services/themes.dart';
import 'package:provider/provider.dart';

final primary = Colors.indigoAccent.shade700;

// ignore: must_be_immutable
class HomePagev2 extends StatefulWidget {
  HomePagev2({super.key, this.initialUrl});
  String? initialUrl;
  @override
  State<HomePagev2> createState() => _HomePagev2State();
}

class _HomePagev2State extends State<HomePagev2> {
  late InAppWebViewController controller =
      InAppWebViewController.fromPlatformCreationParams(
    params:
        const PlatformInAppWebViewControllerCreationParams(id: 'controller'),
  );
  late PullToRefreshController refresh;
  bool loadingError = false;
  bool controllerDisposed = false;
  _refresh() {
    // make refresh to stop
    controller.reload().then((_) => refresh.endRefreshing());
    debugPrint('refresh');
  }

  @override
  void initState() {
    super.initState();
    refresh = PullToRefreshController.fromPlatformCreationParams(
      params:
          PlatformPullToRefreshControllerCreationParams(onRefresh: _refresh),
    )..setEnabled(true);
  }

  @override
  void dispose() {
    controllerDisposed = true;

    // controller.dispose();
    // // refresh.dispose();
    // controllerDisposed = true;
    super.dispose();
  }

  onError() {
    setState(() {
      loadingError = true;
    });
  }

  clearError() {
    setState(() {
      loadingError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.initialUrl ??= 'https://charlesclicksvtu.com/mobile/login/';

    final provider =
        Provider.of<WebViewProgressProvider>(context, listen: false);

    final prefs = Provider.of<AuthProvider>(context, listen: false).pref;
    final cookies = prefs.getStringList('cookies') ?? [];
    return Scaffold(
        backgroundColor: primaryColor,
        floatingActionButton: loadingError
            ? FloatingActionButton(
                onPressed: () async {
                  print('loading error $loadingError');
                  _refresh();
                  clearError();
                },
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              )
            : Container(),
        body: SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              if (controllerDisposed) return true;
              final canGoBack = await controller.canGoBack();
              if (canGoBack) {
                await controller.goBack();
                return false;
              }
              return !canGoBack;
            },
            // wrapper to display and hide error widget
            child: Stack(
              children: [
                Column(
                  children: [
                    Consumer<WebViewProgressProvider>(builder:
                        (BuildContext context, WebViewProgressProvider value,
                            Widget? child) {
                      if (value.isLoading) {
                        return LinearProgressIndicator(
                          value: value.progress,
                        );
                      }
                      return Container();
                    }),
                    Expanded(
                      child: InAppWebView(
                        initialSettings: InAppWebViewSettings(
                          javaScriptEnabled: true,
                          sharedCookiesEnabled: true,
                        ),
                        onWebViewCreated: (controller) async {
                          this.controller = controller;
                        },
                        onReceivedError: (x, y, err) {
                          if (err.type == WebResourceErrorType.HOST_LOOKUP) {
                            print('host lookup error');
                            onError();
                          }
                        },
                        pullToRefreshController: refresh,
                        onLoadStart: (_, uri) {
                          provider.setLoading(true);
                        },
                        onLoadStop: (_, uri) {
                          provider.setLoading(false);
                          print('loading stopped');
                        },
                        onProgressChanged: (_, prog) {
                          if (provider.isLoading) {
                            provider.updateProgress(prog / 100);
                          }
                        },
                        initialUrlRequest:
                            URLRequest(url: WebUri(widget.initialUrl!)),
                      ),
                    ),
                  ],
                ),
                if (loadingError)
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ColoredBox(
                      color: Colors.white,
                      child: ErrorScreen(
                        reload: () async {
                          await controller.reload();
                          clearError();
                          return true;
                        },
                      ),
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}
