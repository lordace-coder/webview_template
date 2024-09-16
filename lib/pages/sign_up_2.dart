import 'package:charles_click/models/app_lock_provider.dart';
import 'package:charles_click/services/functions.dart';
import 'package:charles_click/services/requests.dart';
import 'package:charles_click/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:provider/provider.dart';
import './sign_in_page.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class SignIn2 extends StatefulWidget {
  SignIn2({super.key, this.useBiometrics = false});

  bool useBiometrics;
  @override
  State<SignIn2> createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  bool isloading = false;

  @override
  void dispose() {
    // Dispose of each controller

    super.dispose();
  }

  /// sign user in
  unlock(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    // final canCheckBio = await auth.canCheckBiometrics;
    // final supportedDevice = await auth.isDeviceSupported();
    // print('can check biometrics $canCheckBio');
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to use this application',
          options: const AuthenticationOptions(useErrorDialogs: false));
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        // Some biometrics are enrolled.
      }

      // Use checks like this with caution!
      if (didAuthenticate) {
        AppLock.of(context)?.didUnlock();
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // ...
      } else {
        // ...
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),

                Image.asset(
                  height: 50,
                  width: 200,
                  'assets/mainlogo.png',
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                // AppLargeText(
                //   text: 'Welcome Back',
                //   color: Colors.indigoAccent.shade700,
                // ),

                AppSmallText(
                  text: !widget.useBiometrics
                      ? 'Enter your password to continue'
                      : 'Login with fingerprint instead',
                  alignCenter: true,
                ),
                const SizedBox(
                  height: 80,
                ),
                AppButton(
                    text: 'Login',
                    backgroundColor:primaryColor,
                    textColor: Colors.white,
                    onTap: () {
                      unlock(context);
                    },
                    isloading: isloading),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
