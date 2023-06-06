import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilehrmss/screens/attendenceScreen.dart';
import 'package:mobilehrmss/screens/errorScreen.dart';
import 'package:mobilehrmss/screens/homeScreen.dart';
import 'package:mobilehrmss/screens/splashScreen.dart';
import 'package:mobilehrmss/screens/loginPage.dart';
import 'models/AppColors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return attendenceScreen();
          } else {
            return loginPage();
          }
        },

      ),
          routes: {
            homeScreen.routeName: (ctx) => homeScreen(),
            errorPage.routeName: (ctx) => errorPage(imagePath: ''),
            splashScreen.routeName: (ctx) => splashScreen(),
            loginPage.routeName: (ctx) => loginPage(),
            attendenceScreen.routeName: (ctx) => attendenceScreen(),

    },
    );
  }
}
