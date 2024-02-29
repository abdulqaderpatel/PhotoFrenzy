import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/authentication/login.dart';
import 'package:photofrenzy/authentication/verify_email.dart';
import 'package:photofrenzy/main_pages/user_navigation_bar.dart';
import 'package:photofrenzy/themes/dark_theme.dart';
import 'package:photofrenzy/themes/light_theme.dart';
import 'Notifications/notification_service.dart';
import 'controllers/user_controller.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NjJbkSDqOoAu1YvgQpN7weD8MzoNFW7rCOPBMnAZaJlWnpXkW2EvauiTP8PYpnQC73YJbX9K3jnkMBqVKTHqdTE00frWxNHzF";
  NotificationService().initNotification();
  tz.initializeTimeZones();
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
  UserController userController = Get.put(UserController());
  var user = FirebaseAuth.instance.currentUser;
  var isDataLoaded = true;
  var userExists = true;
  var userVerified = true;

  @override
  void initState() {
    if (user == null) {
      userExists = false;
    } else {
      if (user!.emailVerified == false) {
        userVerified = false;
        userController.isLoggedOut.value = false;
      } else {
        userController.isLoggedOut.value = false;
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
      home: userExists == false
          ? const LoginScreen()
          : (userVerified == false
              ? const VerifyEmailScreen(
                  username: "timepass",
                )
              : const UserNavigationBar()),
    );
  }
}
