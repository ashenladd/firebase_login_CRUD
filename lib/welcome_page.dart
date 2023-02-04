import 'package:firebase_login/widgets/app_large_text.dart';
import 'package:firebase_login/widgets/app_text.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Colors.white70,
                    radius: 60,
                    backgroundImage: AssetImage('img/profile1.png'),
                  )
                ],
              ),
            ),
          ]),
          const SizedBox(height: 70),
          Container(
            margin: const EdgeInsets.only(left: 20),
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppLargeText(
                  text: "Welcome",
                  size: 36,
                  color: Colors.black54,
                ),
                AppText(
                  text: "User@gmail.com",
                  color: Colors.grey,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 90),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('img/loginbtn.png'), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)),
              child: const Center(
                child: (AppLargeText(
                  text: 'Sign Out',
                  color: Colors.white,
                  size: 27,
                )),
              )),
        ]),
      ),
    );
  }
}
