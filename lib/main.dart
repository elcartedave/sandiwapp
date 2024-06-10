import 'package:flutter/material.dart';
import 'package:sandiwapp/auth_pages.dart/LogoPage.dart';

void main() async {
  runApp(const RootWidget());
}

class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandiwapp',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => const LogoPage()},
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xffEEEEEE)),
        useMaterial3: true,
      ),
    );
  }
}
