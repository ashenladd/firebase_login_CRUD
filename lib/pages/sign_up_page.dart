import 'package:firebase_login/auth_controller.dart';
import 'package:firebase_login/widgets/app_large_text.dart';
import 'package:firebase_login/widgets/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    List images = ['g.png', 't.png', 'f.png'];
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(children: [
            Container(
              width: w,
              height: h * 0.3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/signup.png"), fit: BoxFit.cover)),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: h * 0.15,
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white54,
                    radius: 60,
                    backgroundImage: AssetImage('img/profile.png'),
                  )
                ],
              ),
            ),
          ]),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: w,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          borderSide: const BorderSide(color: Colors.white))),
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
                  obscureText: true,
                  controller: passwordController,
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
            ]),
          ),
          const SizedBox(height: 70),
          GestureDetector(
            //Trim() menghapus baris baru
            onTap: () => AuthController.instance.register(
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
                    text: 'Sign Up',
                    color: Colors.white,
                    size: 27,
                  )),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(
            text: "Have an account?",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.back();
              },
          )),
          SizedBox(height: w * 0.2),
          AppText(
            text: "Sign up using the following method",
            color: (Colors.grey[500])!,
          ),
          Wrap(
              children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsetsDirectional.all(10),
              child: CircleAvatar(
                radius: 23,
                backgroundColor: Colors.grey[500],
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("img/${images[index]}"),
                ),
              ),
            );
          }))
        ]),
      ),
    );
  }
}
