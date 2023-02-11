import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/widgets/app_large_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;

  const EditProfilePage({super.key, required this.documentSnapshot});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _cityController = TextEditingController();

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          flexibleSpace: const Image(
            image: AssetImage('img/loginbtn.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Name",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _ageController,
              decoration: InputDecoration(
                hintText: "Age",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: "City",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                final String name = _nameController.text;
                final String age = _ageController.text;
                final String city = _cityController.text;

                await _users
                    .doc(widget.documentSnapshot!.id)
                    .update({'name': name, 'age': age, 'city': city});

                _nameController.text = '';
                _ageController.text = '';
                _cityController.text = '';
                Get.back();
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage('img/loginbtn.png'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                    child: (AppLargeText(
                      text: 'Edit Profile',
                      color: Colors.white,
                      size: 27,
                    )),
                  )),
            ),
          ],
        ));
  }
}
