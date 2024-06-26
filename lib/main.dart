import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';
import 'package:sandiwapp/providers/event_provider.dart';
import 'package:sandiwapp/providers/forms_provider.dart';
import 'package:sandiwapp/providers/message_provider.dart';
import 'package:sandiwapp/providers/payment_provider.dart';
import 'package:sandiwapp/providers/task_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/screens/users/UserHomePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
      ChangeNotifierProvider(create: ((context) => UserProvider())),
      ChangeNotifierProvider(create: ((context) => AnnouncementProvider())),
      ChangeNotifierProvider(create: ((context) => TaskProvider())),
      ChangeNotifierProvider(create: ((context) => MessageProvider())),
      ChangeNotifierProvider(create: ((context) => EventProvider())),
      ChangeNotifierProvider(create: ((context) => FormsProvider())),
      ChangeNotifierProvider(create: ((context) => PaymentProvider())),
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
      routes: {
        '/': (context) => const HomePage(),
        '/userPage': (context) => const UserHomePage()
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xffEEEEEE)),
        useMaterial3: true,
      ),
    );
  }
}
