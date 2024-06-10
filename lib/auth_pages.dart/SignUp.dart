import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _collegeaddressController = TextEditingController();
  final _homeaddressController = TextEditingController();
  final _contactnumberController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Sign Up",
          style: GoogleFonts.patrickHandSc(color: Colors.black, fontSize: 30),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Mag Sign Up sa Sandiwapp",
                        style: GoogleFonts.patrickHandSc(
                            color: Colors.black, fontSize: 34),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Name",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _nameController,
                      obscureText: false,
                      hintText: "Enter your name"),
                  const SizedBox(height: 10),
                  Text(
                    "Nickname",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _nicknameController,
                      obscureText: false,
                      hintText: "Enter your nickname"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Birthday (mm/dd/yy)",
                              style: blackText,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),
                            MyTextField2(
                              controller: _birthdayController,
                              obscureText: false,
                              hintText: "Enter your birthday",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Age",
                              style: blackText,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),
                            MyTextField2(
                              controller: _ageController,
                              obscureText: false,
                              hintText: "Enter your age",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Contact Number",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _contactnumberController,
                      obscureText: false,
                      hintText: "Enter your number"),
                  const SizedBox(height: 10),
                  Text(
                    "College Address",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _collegeaddressController,
                      obscureText: false,
                      hintText: "Enter your address"),
                  const SizedBox(height: 10),
                  Text(
                    "Home Address",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _homeaddressController,
                      obscureText: false,
                      hintText: "Enter your address"),
                  const SizedBox(height: 10),
                  Text(
                    "Email Address",
                    style: blackText,
                  ),
                  const SizedBox(height: 5),
                  MyTextField2(
                      controller: _emailController,
                      obscureText: false,
                      hintText: "Enter your email"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: blackText,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),
                            MyTextField2(
                              controller: _passwordController,
                              obscureText: true,
                              hintText: "Enter password",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Confirm Password",
                              style: blackText,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),
                            MyTextField2(
                              controller: _confirmpasswordController,
                              obscureText: true,
                              hintText: "Confirm password",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !_isLoading
                          ? BlackButton(
                              text: "SIGN UP",
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _formKey.currentState!.save();
                                  String? message = await context
                                      .read<UserAuthProvider>()
                                      .authService
                                      .signUp(
                                          _nameController.text,
                                          _nicknameController.text,
                                          _birthdayController.text,
                                          _ageController.text,
                                          _contactnumberController.text,
                                          _collegeaddressController.text,
                                          _homeaddressController.text,
                                          _emailController.text,
                                          _passwordController.text);
                                  setState(() {
                                    _isLoading = false;
                                    if (message != "" && message!.isNotEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  message))); //shows error message
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(message!)));

                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              },
                            )
                          : const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 10),
                      MyTextButton(
                        text: "Go Back",
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              )),
        ),
      )),
    );
  }
}
