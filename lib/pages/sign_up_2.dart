import 'package:charles_click/services/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import './sign_in_page.dart';

class SignIn2 extends StatefulWidget {
  SignIn2({super.key, this.useBiometrics = false});

  bool useBiometrics;
  @override
  State<SignIn2> createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  final phone = TextEditingController();
  final passwordController = TextEditingController();

  bool isvisible = false;
  bool formIsValid() {
    if (passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  bool isloading = false;

  @override
  void dispose() {
    // Dispose of each controller

    passwordController.dispose();
    phone.dispose();

    super.dispose();
  }

  /// sign user in
  unlock() async {
    AppLock.of(context)?.didUnlock();
    await isAuthenticated(
      phone: phone.text,
      password: passwordController.text,
    );
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
                const Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.arrow_back),
                    SizedBox(
                      width: 120,
                    ),
                    Text('Login'),
                  ],
                ),
                const SizedBox(height: 90),
                AppLargeText(
                  text: 'Welcome Back',
                  color: Colors.indigoAccent.shade700,
                ),
                const AppSmallText(
                  text: '080*********',
                  alignCenter: false,
                ),
                // const AppSmallText(
                //   text: 'Sign in to get back in the loop!',
                //   alignCenter: false,
                // ),
                // const SizedBox(
                //   height: 80,
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
                if (!widget.useBiometrics) ...[
                  GestureDetector(
                    onTap: () {},
                    child: CustomTextField(
                        isSelected: true,
                        controller: passwordController,
                        hintText: 'Password',
                        icon: const Icon(
                          Icons.password_rounded,
                          size: 18,
                        ),
                        isPassword: true),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.indigoAccent.shade700),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 100),
                  AppButton(
                    isloading: isloading,
                    text: 'Login',
                    textColor: Colors.white,
                    backgroundColor: Colors.indigoAccent.shade700,
                    onTap: () async {
                      setState(() {
                        isloading = true;
                      });
                      // !unlock app
                      await unlock();
                      Future.delayed(const Duration(seconds: 3));

                      setState(() {
                        isloading = false;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  AppSmallText(
                    color: Colors.indigoAccent.shade700,
                    text: 'Login with fingerprint instead',
                    alignCenter: false,
                  ),
                ] else ...[
                  Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: Colors.indigoAccent.shade700,
                  ),
                  const SizedBox(height: 80),
                  Text(
                    'Login with password instead',
                    style: TextStyle(color: Colors.indigoAccent.shade700),
                  )
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPopButton extends StatelessWidget {
  final Function()? ontap;
  const CustomPopButton({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 23,
        width: 23,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(7)),
        child: const Icon(
          Icons.arrow_back_ios_new_sharp,
          size: 14,
        ),
      ),
    );
  }
}
