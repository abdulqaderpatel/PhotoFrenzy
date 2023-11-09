import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String svgImage = "assets/images/email_sent.svg";

  var loadingIcons = 0;
  var loadingString = "";

  void emailVerificationLoading() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      if(loadingIcons==8)
        {
          setState(() {
            loadingIcons=1;
            loadingString=". ";
          });
        }
      else{
        setState(() {
          loadingIcons++;
          loadingString+=". ";
        });
      }
    });
  }

  @override
  void initState() {
    emailVerificationLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              left: Get.width * 0.05, right: Get.width * 0.05, top: 10),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.25,
                child: SvgPicture.asset(svgImage, semanticsLabel: 'Acme Logo'),
              ),
              Gap(Get.height * 0.03),
              Text(
                "Check your email",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Gap(Get.height * 0.02),
              const Text(
                "A verification email has been sent to the email provided by you. Kindly confirm the email by tapping the button below",
              ),
              Gap(Get.height * 0.1),
              SizedBox(
                height: Get.height * 0.06,
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    AndroidIntent intent = const AndroidIntent(
                        action: 'android.intent.action.MAIN',
                        category: 'android.intent.category.APP_EMAIL',
                        flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
                    intent.launch().catchError((e) {});
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: Text(
                    "Check Email",
                    style: GoogleFonts.lato(
                        letterSpacing: 0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ),
              ),
              Gap(Get.height * 0.05),
              Text(loadingString,style: TextStyle(fontSize: 24,color: Colors.blue),)
            ],
          ),
        ),
      ),
    );
  }
}
