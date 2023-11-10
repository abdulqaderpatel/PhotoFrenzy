import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/authentication/login.dart';
import 'package:photofrenzy/authentication/verify_email.dart';
import 'package:photofrenzy/main_pages/user_navigation_bar.dart';
import 'package:photofrenzy/themes/dark_theme.dart';
import 'package:photofrenzy/themes/light_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var user=FirebaseAuth.instance.currentUser;
  var isDataLoaded=true;
  var userExists=true;
  var userVerified=true;
  @override
  void initState() {

    if(user==null)
    {
      userExists=false;
    }
    else {
      if (user!.emailVerified == false) {
        userVerified = false;
      }
    }
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home:userExists==false? LoginScreen():(userVerified==false?VerifyEmailScreen():UserNavigationBar()),
    );
  }
}