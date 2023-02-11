import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/auth_controller.dart';
import 'package:firebase_login/pages/edit_profile_page.dart';
import 'package:firebase_login/widgets/app_large_text.dart';
import 'package:firebase_login/widgets/app_text.dart';
import 'package:firebase_login/widgets/column_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class WelcomePage extends StatefulWidget {
  final String email;

  const WelcomePage({super.key, required this.email});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _nameFavoritefood = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  List<Map<String, dynamic>> _items = [];

  //Creating box
  final _favoriteFoodsBox = Hive.box("favoriteFoodsBox");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _favoriteFoodsBox.keys.map((key) {
      final item = _favoriteFoodsBox.get(key);
      return {"key": key, "name": item["name"]};
    }).toList();
    setState(() {
      _items = data.toList();
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _favoriteFoodsBox.add(newItem);
    _refreshItems(); //Refresh UI
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _favoriteFoodsBox.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(int itemKey) async {
    await _favoriteFoodsBox.delete(itemKey);
    _refreshItems();
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameFavoritefood.text = existingItem['name'];
    }

    //Widget popup
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _nameFavoritefood,
                  decoration: InputDecoration(
                      hintText: "Food Name",
                      suffixIcon: IconButton(
                        onPressed: _nameFavoritefood.clear,
                        icon: const Icon(Icons.clear),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (itemKey == null) {
                      //Passing argumen map
                      _createItem({"name": _nameFavoritefood.text});
                    } else {
                      _updateItem(
                          itemKey, {'name': _nameFavoritefood.text.trim()});
                    }

                    _nameFavoritefood.text = "";
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('img/loginbtn.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(30)),
                    child: AppText(
                      text: itemKey == null ? "Add Item" : "Update Item",
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

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
                    backgroundColor: Colors.white54,
                    radius: 60,
                    backgroundImage: AssetImage('img/profile.png'),
                  )
                ],
              ),
            ),
          ]),
          const SizedBox(height: 70),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLargeText(
                  text: "Welcome",
                  size: 36,
                  color: Colors.black54,
                ),
                AppText(
                  text: "Email: ${widget.email}",
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                    stream: _users.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return ColumnBuilder(
                            textDirection: TextDirection.ltr,
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];
                              if (documentSnapshot['id'] ==
                                  documentSnapshot.id) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: "Name: ${documentSnapshot['name']}",
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppText(
                                      text: "Age: ${documentSnapshot['age']}",
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppText(
                                      text: "City: ${documentSnapshot['city']}",
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Get.to(EditProfilePage(
                                            documentSnapshot: documentSnapshot,
                                          ));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'img/loginbtn.png'),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              AppText(
                                                text: "Edit Profile",
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        )),
                                  ],
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 5,
                ),
                const AppLargeText(
                  text: 'Your Favortie Food',
                  size: 24,
                  color: Colors.black54,
                ),
                Wrap(
                  children: List.generate(_items.length, (index) {
                    final currentItem = _items[index];
                    return Container(
                      margin: const EdgeInsets.all(1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color.fromRGBO(239, 70, 55, 0.3),
                              width: 2)),
                      child: GestureDetector(
                        onTap: () {
                          _showForm(context, currentItem['key']);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: currentItem['name'],
                              color: Colors.grey,
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                _deleteItem(currentItem['key']);
                              },
                              icon: Icon(
                                Icons.close_rounded,
                                color: Colors.grey[300],
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                ElevatedButton(
                    onPressed: () {
                      _showForm(context, null);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.grey[200]),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          GestureDetector(
            onTap: () => AuthController.instance.LogOut(),
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
                    text: 'Sign Out',
                    color: Colors.white,
                    size: 27,
                  )),
                )),
          ),
        ]),
      ),
    );
  }
}
