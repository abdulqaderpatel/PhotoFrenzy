import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photofrenzy/authentication/signup.dart';

import '../global/theme_mode.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: Get.width * 0.05,
                right: Get.width * 0.05),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: Get.height * 0.12,
                    width: Get.height * 0.14,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    child: Image.asset(
                      "assets/images/appicon.png",
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Row(
                    children: [
                      Text("Login",
                          style: Theme.of(context).textTheme.displayLarge),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Please Sign in to continue",
                          style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                  Gap(Get.height * 0.1),
                  TextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 20, bottom: 20),
                        prefixIcon: const Icon(Icons.email),
                        hintText: "Enter Email",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: InputBorder.none),
                  ),
                  Gap(Get.height * 0.013),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 20, bottom: 20),
                        prefixIcon: const Icon(Icons.password),
                        hintText: "Enter Password",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: InputBorder.none),
                  ),
                  Gap(Get.height * 0.05),
                  SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: Text(
                        "Login",
                        style: GoogleFonts.lato(
                            letterSpacing: 0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Gap(Get.height*0.05),
                  Row(children: [
                   Expanded(child: Divider(color: isDark(context)!=true?Colors.black87:Colors.grey,)),
                    Container(padding:const EdgeInsets.symmetric(horizontal: 5),child: Text("Or",style: TextStyle(color:  isDark(context)==true?Colors.grey:Colors.black87),)),
                    Expanded(child: Divider(color: isDark(context)!=true?Colors.black87:Colors.grey,)),
                  ],),
                  Gap(Get.height * 0.05),
                  SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(0),
                          backgroundColor:Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),side: const BorderSide(color: Colors.grey,width: 0.4)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/google-logo.png"),
                          Text(
                            "Sign in with google",
                            style: GoogleFonts.lato(
                                letterSpacing: 0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          Container(width: 35,)
                        ],
                      ),
                    ),
                  ),
                  Gap(Get.height*0.05),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Don't have an account? ",
                            style: TextStyle(
                                color: isDark(context) == true
                                    ? Colors.grey
                                    : Colors.blueGrey)),
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SignupScreen();
                              }));
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
