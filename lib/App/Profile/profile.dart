import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/Profile/add_receipe.dart';
import 'package:jualan/App/Profile/setting.dart';
import 'package:jualan/App/detail.dart';
import 'package:jualan/App/models/recipes.dart';
import 'package:jualan/App/models/recipes_service.dart';
import 'package:jualan/App/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/api_service.dart';



class Profile extends StatefulWidget{
  const Profile ({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  int halaman = 0;

  void _switchPage(int pageIndex) {
    setState(() {
      halaman = pageIndex;
    });
  }

  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('user_id') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFFFDF7F1),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 41),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 62),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Setting()),
                      );
                    },
                    icon: Image.asset('assets/images/setting.png'),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const CircleAvatar(
                radius: 75,
                backgroundImage: AssetImage('assets/images/org.png'),
              ),
              const SizedBox(height: 5),
              IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2EC4B6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Muhammad Nayaka Putra',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 16, top: 15, right: 16, bottom: 65),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  height: 520,
                  width: 330,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                        padding: const EdgeInsets.only(left: 37, right: 37, top: 9.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _switchPage(0),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    padding: const EdgeInsets.only(bottom: 7),
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  child: const Text(
                                    'POST',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 7,
                                  width: 57,
                                  decoration: BoxDecoration(
                                    color: halaman == 0 ? Colors.black : Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _switchPage(1),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    padding: const EdgeInsets.only(bottom: 7),
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  child: const Text(
                                    'REPLIES',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 7,
                                  width: 57,
                                  decoration: BoxDecoration(
                                    color: halaman == 1 ? Colors.black : Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 17, right: 17, bottom: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFBF69),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.black),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddReceipe()),
                                  );
                                },
                                icon: Image.asset('assets/images/add.png'),
                                iconSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<int>(
                          future: getUserId(), // Mendapatkan userId dari SharedPreferences
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (userSnapshot.hasError) {
                              return Center(child: Text('Error: ${userSnapshot.error}'));
                            } else if (!userSnapshot.hasData || userSnapshot.data == 0) {
                              return Center(child: Text('User ID not found'));
                            } else {
                              int userId = userSnapshot.data!; // Mendapatkan userId

                              return FutureBuilder<ApiResponse>(
                                future: getRecipesByUser(userId), // Panggil API dengan userId
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.error != null) {
                                    return Center(child: Text('Error: ${snapshot.data!.error}'));
                                  } else {
                                    // Pastikan snapshot.data!.data adalah List<dynamic>
                                    List<Recipes> recipes = List<Recipes>.from(snapshot.data!.data as Iterable);
                                    return SingleChildScrollView(
                                      child: _buildPostContent(recipes),
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostContent(List<Recipes> recipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: recipes.map((recipe) {
            // Menghitung waktu
            final createdAt = recipe.createdAt; // Asumsikan createdAt ada di model Recipes
            final difference = DateTime.now().difference(createdAt);
            final duration = _formatDuration(difference);

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 300,
              height: 81,
              padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
              child: Row(
                children: [
                  Image.asset('assets/images/ayam.png', width: 60, height: 60),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              recipe.recipe_name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Text(
                              duration,
                              style: TextStyle(fontSize: 16, color: Color(0xFFB4B4B4)),
                            ),
                          ],
                        ),
                        const Text(
                          'Bahan-bahan',
                          style: TextStyle(color: Color(0XFF666666), fontSize: 13),
                        ),
                        Row(
                          children: [
                            Text(
                              '• ${_truncateText(recipe.description)}', // Batas deskripsi bahan hingga 15 karakter
                              style: TextStyle(color: Color(0XFF666666), fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Colors.black),
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(top: 9.86, right: 14, left: 14),
                                        width: MediaQuery.of(context).size.width,
                                        height: 485,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const SizedBox(width: 25.0),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1),
                                                    color: const Color(0XFFD9D9D9),
                                                    borderRadius: BorderRadius.circular(50),
                                                  ),
                                                  width: (79.2 / MediaQuery.of(context).size.width) *
                                                      MediaQuery.of(context).size.width,
                                                  height: 8.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Image.asset('assets/images/closeprof.png'),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 17.59),
                                            Center(
                                              child: Text(
                                                recipe.recipe_name,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1, color: Colors.black),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  width: 100,
                                                  height: 100,
                                                  child: Image.asset(
                                                    'assets/images/${recipe.image}.png',
                                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                      return Image.asset('assets/images/ayam.png'); // Gambar default
                                                    },
                                                  ),

                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 39),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 15),
                                                  const Text('Bahan - Bahan'),
                                                  const SizedBox(height: 8),
                                                  Text(recipe.description),  // Menampilkan deskripsi dinamis
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'More...',
                                style: TextStyle(
                                  color: Color(0XFF3CBCFF),
                                  fontSize: 13,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],

                    ),

                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6,),
      ],
    );

  }
  String _formatDuration(Duration duration) {
    if (duration.inDays >= 7) {
      int weeks = duration.inDays ~/ 7;
      return '$weeks w'; // Menggunakan format minggu
    } else if (duration.inDays > 0) {
      return '${duration.inDays}d'; // Menggunakan format hari
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h'; // Menggunakan format jam
    } else {
      return '${duration.inMinutes}m'; // Menggunakan format menit
    }
  }

// Fungsi untuk memotong teks hingga 15 karakter
  String _truncateText(String text) {
    if (text.length > 15) {
      return text.substring(0, 15) + '...'; // Memotong teks dan menambahkan "..."
    }
    return text;
  }
  Widget _buildRepliesContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halamaan Replies',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          'Halo',
        ),
      ],
    );
  }
}