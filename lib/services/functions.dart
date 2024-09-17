import 'package:flutter/material.dart';
import 'package:charles_click/pages/home_pagev2.dart';

handleForgotPassword(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => HomePagev2(
        initialUrl: 'https://charlesclicksvtu.com/mobile/recovery/',
      ),
    ),
  );
}
