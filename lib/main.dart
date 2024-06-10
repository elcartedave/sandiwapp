import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/auth_pages.dart/LogoPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => UserAuthProvider()))
    ],
    child: const RootWidget(),
  ));
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
