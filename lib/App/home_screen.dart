import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/detail.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/recipes.dart';
import 'package:jualan/App/models/recipes_service.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/register.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _menuList = [];
  bool _loading = true;
  int userId = 0;

  Future<void> menuPosts() async {
    userId = (await getUserId())!;
    ApiResponse response = await getMenu();

    if(response.error == null){

      setState(() {
        _menuList = response.data as List<dynamic>;
        _loading = false;
      });
    }
    else if(response.error == unauthorized){
      logout().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    menuPosts();
  }

  @override
  Widget build(BuildContext context) {
    const padleft = EdgeInsets.only(left: 19.96);
          return Scaffold(
            backgroundColor: Colors.white,
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 9,),
                  Container(
                    padding: const EdgeInsets.only(left: 19.96, top: 18.92),
                    child: Image.asset('assets/images/toshome.png', height: 60.4, width: 111.9,),
                  ),
                  const SizedBox(height: 17.68,),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                                color: Color(0xFF5A5A5A)
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(),
                            ),
                            contentPadding: const EdgeInsets.only(top: 10, left: 35)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    padding: padleft,
                    child: const Text('Rekomendasi Menu Hari Ini', style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                  const SizedBox(height: 11,),
                  Container(
                    margin: const EdgeInsets.only(left: 19.96),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _menuList.map((recipe) {
                          return Container(
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            height: 160,
                            width: 120,
                            child: Container(
                              margin: const EdgeInsets.only(left: 9, top: 6, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(recipe.image ?? 'assets/images/imgayam.png', width: 103, height: 69,),
                                  const SizedBox(height: 7,),
                                   Text(
                                    recipe.recipe_name ?? 'Resep',
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    recipe.waktu_pembuatan ?? '',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666)
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.black, // Warna border
                                            width: 1, // Lebar border
                                          ),
                                        ),
                                        width: 50,
                                        height: 24,
                                        child: ElevatedButton(onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Detail()));
                                        },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0XFFBCFFC1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                ),
                                                padding: const EdgeInsets.only(left: 9, right: 8)
                                            ),
                                            child: const Text('Baca',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                )
                                            )
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.black, // Warna border
                                            width: 1, // Lebar border
                                          ),
                                        ),
                                        width: 50,
                                        height: 24,
                                        child: ElevatedButton(onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                        },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0XFFFBFFBC),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                ),
                                                padding: const EdgeInsets.only(left: 9, right: 8)
                                            ),
                                            child: const Text('Save',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                )
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11,),
                  Container(
                    padding: padleft,
                    child: const Text('Trending now 🔥', style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                  const SizedBox(height: 8,),
                  Container(
                    margin: const EdgeInsets.only(left: 19.96),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                height: 160,
                                width: 120,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 9, top: 6, right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/imgayam.png', width: 103, height: 69,),
                                      const SizedBox(height: 7,),
                                      const Text('Ayam Bawang',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Text('1j 2m',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF666666)
                                        ),
                                      ),
                                      const SizedBox(height: 9),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.black, // Warna border
                                                width: 1, // Lebar border
                                              ),
                                            ),
                                            width: 50,
                                            height: 24,
                                            child: ElevatedButton(onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                            },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0XFFBCFFC1),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                    ),
                                                    padding: const EdgeInsets.only(left: 9, right: 8)
                                                ),
                                                child: const Text('Baca',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.black, // Warna border
                                                width: 1, // Lebar border
                                              ),
                                            ),
                                            width: 50,
                                            height: 24,
                                            child: ElevatedButton(onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                            },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0XFFFBFFBC),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                    ),
                                                    padding: const EdgeInsets.only(left: 9, right: 8)
                                                ),
                                                child: const Text('Save',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Image.asset('assets/images/juara1.png', width: 50, height: 49.62,),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                height: 160,
                                width: 120,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 9, top: 6, right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/imgayam.png', width: 103, height: 69,),
                                      const SizedBox(height: 7,),
                                      const Text('Ayam Bawang',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Text('1j 2m',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF666666)
                                        ),
                                      ),
                                      const SizedBox(height: 9),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.black, // Warna border
                                                width: 1, // Lebar border
                                              ),
                                            ),
                                            width: 50,
                                            height: 24,
                                            child: ElevatedButton(onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                            },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0XFFBCFFC1),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                    ),
                                                    padding: const EdgeInsets.only(left: 9, right: 8)
                                                ),
                                                child: const Text('Baca',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.black, // Warna border
                                                width: 1, // Lebar border
                                              ),
                                            ),
                                            width: 50,
                                            height: 24,
                                            child: ElevatedButton(onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                            },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0XFFFBFFBC),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                    ),
                                                    padding: const EdgeInsets.only(left: 9, right: 8)
                                                ),
                                                child: const Text('Save',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Image.asset('assets/images/juara1.png', width: 50, height: 49.62,),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                height: 160,
                                width: 120,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 9, top: 6, right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/images/imgayam.png', width: 103, height: 69,),
                                      const SizedBox(height: 7,),
                                      const Text('Ayam Bawang',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Text('1j 2m',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF666666)
                                        ),
                                      ),
                                      const SizedBox(height: 9),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.black, // Warna border
                                                width: 1, // Lebar border
                                              ),
                                            ),
                                            width: 50,
                                            height: 24,
                                            child: ElevatedButton(onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                            },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0XFFBCFFC1),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                    ),
                                                    padding: const EdgeInsets.only(left: 9, right: 8)
                                                ),
                                                child: const Text('Baca',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.black, // Warna border
                                                width: 1, // Lebar border
                                              ),
                                            ),
                                            width: 50,
                                            height: 24,
                                            child: ElevatedButton(onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                            },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color(0XFFFBFFBC),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15), // Border radius tombol
                                                    ),
                                                    padding: const EdgeInsets.only(left: 9, right: 8)
                                                ),
                                                child: const Text('Save',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    )
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Image.asset('assets/images/juara1.png', width: 50, height: 49.62,),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 11,),
                  Container(
                    padding: padleft,
                    child: const Text('Kategori', style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                  const SizedBox(height: 9,),
                  Container(
                    margin: const EdgeInsets.only(left: 19.96),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 1.0
                                  ),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              height: 120,
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/protein.png', width: 97, height: 57,),
                                  const SizedBox(height: 7,),
                                  const Text('Protein', style: TextStyle(
                                      fontSize: 12
                                  ),)
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 1.0
                                  ),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              height: 120,
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/karbo.png', width: 97, height: 57,),
                                  const SizedBox(height: 7,),
                                  const Text('Protein', style: TextStyle(
                                      fontSize: 12
                                  ),)
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 1.0
                                  ),
                                  borderRadius: BorderRadius.circular(15.0)
                              ),
                              height: 120,
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/spices.png', width: 97, height: 57,),
                                  const SizedBox(height: 7,),
                                  const Text('Protein', style: TextStyle(
                                      fontSize: 12
                                  ),)
                                ],
                              ),
                            ),
                          ]
                      ),
                    ),
                  )
                ],
              ),
            ),
          );

  }
}

