import 'package:firebase_login/auth_controller.dart';
import 'package:firebase_login/pages/sign_up_page.dart';
import 'package:firebase_login/widgets/app_large_text.dart';
import 'package:firebase_login/widgets/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: h * 0.3,
            width: w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("img/loginimg.png"), fit: BoxFit.cover),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: w,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const AppLargeText(
                text: "Hello",
              ),
              const AppText(
                text: "Sign Into Your Account",
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 7,
                          blurRadius: 10,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.2))
                    ]),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.deepOrangeAccent,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 7,
                          blurRadius: 10,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.2))
                    ]),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(
                      Icons.key,
                      color: Colors.deepOrangeAccent,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  const AppText(
                    text: "Forgot your password?",
                    color: Colors.grey,
                  ),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 70),
          GestureDetector(
            onTap: () => AuthController.instance.Login(
                emailController.text.trim(), passwordController.text.trim()),
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 90),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('img/loginbtn.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(30)),
                child: const Center(
                  child: (AppLargeText(
                    text: 'Sign In',
                    color: Colors.white,
                    size: 27,
                  )),
                )),
          ),
          SizedBox(height: w * 0.2),
          RichText(
            text: TextSpan(
                text: "Don't have an account?",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                children: [
                  TextSpan(
                    text: " Create",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => const SignUpPage()),
                  ),
                ]),
          )
        ]),
      ),
    );
  }
}
