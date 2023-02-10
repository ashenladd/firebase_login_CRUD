import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/auth_controller.dart';
import 'package:firebase_login/widgets/app_large_text.dart';
import 'package:firebase_login/widgets/app_text.dart';
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

  List<Map<String, dynamic>> _items = [];

  //Creating box
  final _favoriteFoodsBox = Hive.box("favoriteFoodsBox");

  //Ini akan selalu jalan di setiap state app untuk mengecek item/refresh item
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    //Pertama, kita mendapatkan setiap data
    //_favoriteFoodsBox.keys.map akan menangkap setiap key pada map dan
    //nantinya diinialisasikan sebagai variable key
    final data = _favoriteFoodsBox.keys.map((key) {
      //karena kita sudah menyimpan setiap key-nya pada variabel key
      //kita bisa menggunakan get(key), untuk mendapatkan value dari key tersebut, value-nya disimpan di item
      final item = _favoriteFoodsBox.get(key);
      //mengembalikan setiap key dan valuenya menjadi list
      return {"key": key, "name": item["name"]};
    }).toList();

    //Kedua, setelah mendapatkan setiap data kita menyimpannya di _items
    //kita bisa menggunakan data.reversed.toList() untuk sort items dari paling baru ke paling lama
    setState(() {
      _items = data.toList();
      print("amount of data is ${_items.length}");
    });
  }

  //Fungsi createItem memasukkan input ke dalam box
  //Map mirip seperti dictionary, dengan key dan value
  //Key-nya adalah string,value-nya dynamic
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    //Hive.box jika menggunakan add akan auto-generate key seperti (0, 1, 2)
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

  //Fungsi menampilkan form add
  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      //element ini berisi value dari suatu index, misalnya kyk _items[2],
      //oleh karenanya ketika ditambakan ['key'] sama saja
      //dengan _items[2]['key'] untuk mengakses value dari suatu key map di list
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
                //padding bottom akan menyesuaikan dengan popup keyboard
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
                        icon: Icon(Icons.clear),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (itemKey == null) {
                      //Passing argumen map
                      _createItem({"name": _nameFavoritefood.text});
                    } else if (itemKey != null) {
                      _updateItem(
                          itemKey, {'name': _nameFavoritefood.text.trim()});
                    }

                    //Ini agar ketika kita klik icon add, teks yang diisi sebelumnnya tidak muncul lagi
                    _nameFavoritefood.text = "";
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: AppText(
                      text: itemKey == null ? "Add Item" : "Update Item",
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('img/loginbtn.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                SizedBox(
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
                  text: widget.email,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                AppLargeText(
                  text: 'Your Favortie Food',
                  size: 24,
                  color: Colors.black54,
                ),
                Wrap(
                  children: List.generate(_items.length, (index) {
                    final currentItem = _items[index];
                    return Container(
                      margin: EdgeInsets.all(1),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Color.fromRGBO(239, 70, 55, 0.3),
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
                              padding: EdgeInsets.all(0),
                              constraints: BoxConstraints(),
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
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.grey[200])),
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
