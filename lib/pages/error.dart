import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:charles_click/pages/home_pagev2.dart';
import 'package:lottie/lottie.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key, required this.reload});

  final Future<bool> Function() reload;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  final Dio dio = Dio();
  bool isloading = false;
  String errorText = 'Your connection was interrupted';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/error_lottie.json'),
        const SizedBox(height: 20),
        Text(isloading ? 'Reconnecting...' : errorText),
        const SizedBox(height: 30),
        !isloading
            ? ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });
                  try {
                    var res = await dio.post(
                      'https://example.com',
                      options: Options(
                        sendTimeout: const Duration(seconds: 6),
                      ),
                    );
                    if (res.statusCode == 200) {
                      // todo handle reload here
                      await widget.reload();
                    } else {
                      errorText = 'reload failed';
                      return;
                    }
                  } catch (e) {
                    errorText = 'reload failed';
                    print('dio error $e');
                  } finally {
                    setState(() {
                      isloading = false;
                    });
                  }
                },
                child: const Text(
                  'Reload',
                  style: TextStyle(color: Colors.green),
                ))
            : const CircularProgressIndicator(
                strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                color: Colors.green,
              ),
        const Expanded(child: SizedBox(width: 20)),
        Image.asset(
          height: 50,
          width: 200,
          'assets/mainlogo.png',
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
