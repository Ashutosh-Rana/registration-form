import 'package:demo_app/screens/home_screen.dart';
import 'package:demo_app/screens/signup_screen.dart';
import 'package:demo_app/screens/upload_img.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/login",
        routes: {
          "/login": (context) => LoginScreen(),
          "/signup": (context) => signup(),
          "/home": (context) => Home(),
          "/upload_img": (context) => ImageUploads(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return LoginScreen();
            }
          },
        )

        // home: const LoginScreen()
        );
  }
}
