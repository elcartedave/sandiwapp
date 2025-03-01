import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/screens/LogoLoadingPage.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "LOG IN",
            style: GoogleFonts.patrickHand(color: Colors.black, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Email",
                    style: blackText,
                    textAlign: TextAlign.start,
                  ),
                  MyTextField2(
                      controller: _emailController,
                      obscureText: false,
                      isEmail: true,
                      hintText: "Enter your email"),
                  const SizedBox(height: 8),
                  Text(
                    "Password",
                    style: blackText,
                    textAlign: TextAlign.start,
                  ),
                  MyTextField2(
                    controller: _passwordController,
                    obscureText: true,
                    hintText: "Enter your password",
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlackButton(
                        text: "Log In",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            String? message = await context
                                .read<UserAuthProvider>()
                                .authService
                                .signIn(_emailController.text,
                                    _passwordController.text);

                            setState(() {
                              if (message != "" && message!.isNotEmpty) {
                                _isLoading = false;
                                showCustomSnackBar(context, message, 30);
                              } else {
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextButton(
                        text: "Go Back",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: LogoLoadingPage(),
              ),
            ),
          ),
      ],
    );
  }
}
