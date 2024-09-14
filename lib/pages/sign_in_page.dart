import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  bool isvisible = false;
  bool formIsValid() {
    if (usernameController.text.isEmpty) {
      // showErrorBanner(context, "username is required");
      return false;
    } else if (passwordController.text.isEmpty) {
      // showErrorBanner(context, "Password is required");
      return false;
    }
    return true;
  }

  bool isloggedin = false;
  int currentIndex = 0;
  bool isloading = false;

  @override
  void dispose() {
    // Dispose of each controller

    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
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
                  text: 'Welcome Back!',
                  color: Colors.indigoAccent.shade700,
                ),
                const AppSmallText(
                  text: 'Sign in to get back in the loop!',
                  alignCenter: false,
                ),
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: CustomTextField(
                      isSelected: currentIndex == 0,
                      controller: usernameController,
                      hintText: 'Phone number',
                      icon: const Icon(
                        Icons.person,
                        size: 18,
                      ),
                      isPassword: false),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  child: CustomTextField(
                      isSelected: currentIndex == 1,
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
                    Future.delayed(const Duration(seconds: 3));

                    if (formIsValid()) {
                      final Map<String, String> data = {
                        "username": usernameController.text,
                        "password": passwordController.text,
                      };
                    }
                  },
                ),
                const SizedBox(height: 30),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppLargeText extends StatelessWidget {
  final String text;
  final Color? color;

  const AppLargeText({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 25,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon icon;
  final bool isPassword;
  final bool isSelected;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.isPassword,
    required this.isSelected,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isvisible = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: TextField(
          obscureText: widget.isPassword == false ? isvisible : !isvisible,
          controller: widget.controller,
          cursorColor: Colors.indigoAccent.shade700,
          autocorrect: false,
          decoration: InputDecoration(
            errorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            // focusColor: Colors.orange.shade900,
            border: InputBorder.none,
            hintText: widget.hintText,
            prefixIconColor: widget.isSelected
                ? Colors.indigoAccent.shade700
                : Colors.grey.shade400,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isvisible = !isvisible;
                      });
                    },
                    child: isvisible
                        ? Icon(
                            Icons.visibility_rounded,
                            size: 14,
                            color: widget.isSelected
                                ? Colors.indigoAccent.shade700
                                : Colors.grey.shade400,
                          )
                        : Icon(
                            Icons.visibility_off_outlined,
                            size: 14,
                            color: widget.isSelected
                                ? Colors.indigoAccent.shade700
                                : Colors.grey.shade400,
                          ))
                : null,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigoAccent.shade700),
              borderRadius: BorderRadius.circular(15),
            ),
            prefixIcon: widget.icon,
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Function()? onTap;
  final bool isloading;
  const AppButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    required this.isloading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigoAccent.shade700),
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isloading
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 3),
                    )
                  : const SizedBox(),
              const SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSmallText extends StatelessWidget {
  final String text;
  final bool alignCenter;
  final Color color;
  const AppSmallText(
      {super.key,
      required this.text,
      required this.alignCenter,
      this.color = Colors.black38});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignCenter ? TextAlign.center : TextAlign.start,
      style: TextStyle(fontSize: 12, color: color),
    );
  }
}
