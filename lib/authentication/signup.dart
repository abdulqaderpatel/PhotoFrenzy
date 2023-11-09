import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photofrenzy/authentication/login.dart';
import 'package:photofrenzy/authentication/verify_email.dart';
import 'package:photofrenzy/global/show_message.dart';

import '../global/theme_mode.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var buttonLoading = false;
  var emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Future registerWithEmailAndPassword(
      String name, String password, String email) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    user!.updateDisplayName(nameController.text);
    //added this line
    return user;
  }

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
                      Text("Create Account",
                          style: Theme.of(context).textTheme.displayLarge),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Please enter your details",
                          style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                  Gap(Get.height * 0.1),
                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 20, bottom: 20),
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Enter Name",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: InputBorder.none),
                  ),
                  Gap(Get.height * 0.013),
                  TextField(
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 20, bottom: 20),
                        prefixIcon: const Icon(Icons.verified_user),
                        hintText: "Enter Username",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: InputBorder.none),
                  ),
                  Gap(Get.height * 0.013),
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
                      onPressed: () async {
                        setState(() {
                          buttonLoading = true;
                        });
                        if (nameController.text.isEmpty) {
                          showErrorDialog(context,
                              "Name cannot be empty. Please make sure all the details have been filled.");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else if (usernameController.text.isEmpty) {
                          showErrorDialog(context,
                              "username cannot be empty. Please make sure all the details have been filled.");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else if (emailController.text.isEmpty) {
                          showErrorDialog(context,
                              "email cannot be empty. Please make sure all the details have been filled.");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else if (passwordController.text.isEmpty) {
                          showErrorDialog(context,
                              "password cannot be empty. Please make sure all the details have been filled.");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                            .hasMatch(nameController.text)) {
                          showErrorDialog(
                              context, "The name entered is not valid");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else if (!RegExp(r'^[a-zA-Z0-9]+$')
                            .hasMatch(usernameController.text)) {
                          showErrorDialog(
                              context, "The username entered is not valid");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else if (!emailRegExp
                            .hasMatch(emailController.text)) {
                          showErrorDialog(
                              context, "The email entered is not valid");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else if (passwordController.text.length < 5) {
                          showErrorDialog(context,
                              "password should be atleast 6 characters");
                          setState(() {
                            buttonLoading = false;
                          });
                        } else {
                          try {
                            await registerWithEmailAndPassword(
                                nameController.text,
                                passwordController.text,
                                emailController.text);
                           if(context.mounted)
                             {
                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                 return VerifyEmailScreen();
                               }));
                             }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "email-already-in-use") {
                              if (context.mounted) {
                                showErrorDialog(context,
                                    "the email is already in use");
                              }
                              setState(() {
                                buttonLoading = false;
                              });
                            } else if (e.code == "invalid-email") {
                              if (context.mounted) {
                                showErrorDialog(context,
                                    "the email entered is invalid");
                              }
                              setState(() {
                                buttonLoading = false;
                              });
                            } else if (e.code == "weak-password") {
                              if (context.mounted) {
                                showErrorDialog(context,
                                    "the password entered is weak");
                              }
                              setState(() {
                                buttonLoading = false;
                              });
                            }
                          }
                        }
                        setState(() {
                          buttonLoading = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: buttonLoading
                          ? const CircularProgressIndicator(
                              color: Colors.blue,
                            )
                          : Text(
                              "Create Account",
                              style: GoogleFonts.lato(
                                  letterSpacing: 0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                    ),
                  ),
                  Gap(Get.height * 0.05),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Already have an account? ",
                            style: TextStyle(
                                color: isDark(context) == true
                                    ? Colors.grey
                                    : Colors.blueGrey)),
                        InkWell(
                          onTap: () {
                            print(FirebaseAuth
                                .instance.currentUser!.emailVerified);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
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
