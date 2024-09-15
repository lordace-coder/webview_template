import 'package:charles_click/pages/home_pagev2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final Dio dio = Dio();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Lottie.asset('assets/error_lottie.json'),
          const SizedBox(height: 20),
          Text(isloading
              ? 'Reconnecting...'
              : 'Your connection was interrupted'),
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
                      );
                      if (res.statusCode == 200) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return HomePagev2();
                        }));
                      } else {
                        return;
                      }
                    } catch (e) {
                      print(e);
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
      ),
    );
  }
}
