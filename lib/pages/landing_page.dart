import 'package:charles_click/pages/home_pagev2.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});
  final primary = Colors.indigoAccent.shade700;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('assets/landing-bg.jpg').image,
            fit: BoxFit.cover,
          ),
        ),
        child: ColoredBox(
          color: Colors.black38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Row(),
              const SizedBox(
                height: 30,
              ),
              Text(
                'some info on the app'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Row(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomePagev2(
                                  initialUrl:
                                      'https://charlesclicksvtu.com/mobile/login',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ), // Adjust the radius as needed
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: primary,
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomePagev2(
                                  initialUrl:
                                      'https://charlesclicksvtu.com/mobile/register',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ), // Adjust the radius as needed
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: primary,
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
