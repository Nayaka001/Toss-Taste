import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jualan/App/detail.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/constant.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<dynamic> favourites = []; // Menyimpan daftar favorit
  int userId = 0; // Mendeklarasikan userId

  @override
  void initState() {
    super.initState();
    fetchUserId(); // Memuat userId saat screen dibuka
  }

  /// Mengambil userId dari SharedPreferences dan memanggil fetchFavourites
  Future<void> fetchUserId() async {
    final id = await getUserId();  // Ambil userId
    setState(() {
      userId = id;  // Simpan userId
    });
    fetchFavourites();  // Memanggil fetchFavourites setelah userId tersedia
  }

  /// Mendapatkan user ID dari SharedPreferences
  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('user_id') ?? 0;  // Mengambil userId atau default 0
  }

  /// Mengambil data favorit dari API
  Future<void> fetchFavourites() async {
    if (userId == 0) return;

    try {
      final favUrl = await getFav(userId);
      final response = await http.get(Uri.parse(favUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched favourites: $data");
        setState(() {
          favourites = data['data'] ?? []; // Simpan daftar favorit
        });
      } else {
        throw Exception('Failed to load favourites');
      }
    } catch (e) {
      print('Error fetching favourites: $e');
      throw Exception('Failed to load favourites');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1), // Light beige background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF7F1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Favourites',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: favourites.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Menunggu data
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 150 / 190, // Aspect ratio for the cards
          ),
          itemBuilder: (context, index) {
            if (index >= favourites.length || favourites[index]['recipes'] == null) {
              return const SizedBox(); // Tampilkan placeholder jika data tidak valid
            }

            final recipe = favourites[index]['recipes'];
            return FavouritesCard(
              recipeId: recipe['recipe_id'] ?? 'Unknown ID',
              recipe_name: recipe['recipe_name'] ?? 'Unknown Recipe',
              waktu_pembuatan: recipe['waktu_pembuatan'] ?? 'Unknown Time',
              imageUrl: 'assets/images/${recipe['image']}',
            );
          },

        ),
      ),
    );
  }
}

class FavouritesCard extends StatelessWidget {
  final int recipeId;
  final String recipe_name;
  final String waktu_pembuatan;
  final String imageUrl;

  const FavouritesCard({
    super.key,
    required this.recipeId,
    required this.recipe_name,
    required this.waktu_pembuatan,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Lebar kartu
      height: 230, // Tinggi kartu ditingkatkan untuk memberikan ruang lebih
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5), // Border hitam untuk kartu
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        elevation: 2,
        margin: EdgeInsets.zero, // Menghapus margin default pada kartu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan kolom
          children: [
            const SizedBox(height: 8), // Jarak antara kartu dan gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(35.0)),
              child: Image.asset(
                imageUrl, // Path lokal gambar
                width: 160,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Placeholder jika gambar tidak ditemukan
                },
              ),
            ),
            const SizedBox(height: 4), // Jarak antara gambar dan teks
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Menyelaraskan teks ke kiri
              children: [
                Text(
                  recipe_name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Ukuran font untuk nama
                ),
                Text(
                  waktu_pembuatan,
                  style: const TextStyle(color: Colors.black, fontSize: 18), // Ukuran font untuk waktu
                ),
              ],
            ),
            const SizedBox(height: 10), // Jarak lebih besar untuk memberi ruang pada tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Pusatkan tombol
              children: [
                // Tombol Baca
                Padding(
                  padding: const EdgeInsets.only(right: 5), // Jarak antar tombol
                  child: ActionButton(
                    label: 'Baca',
                    backgroundColor: Colors.yellow,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detail(recipeId: recipeId),
                        ),
                      );
                    },
                  ),
                ),
                // Tombol Hapus
                Padding(
                  padding: const EdgeInsets.only(left: 5), // Jarak antar tombol
                  child: ActionButton(
                    label: 'Hapus',
                    backgroundColor: Colors.yellow,
                    onPressed: () {
                      // Aksi untuk menghapus
                    },
                  ),
                ),
              ],
            ),
            const Spacer(), // Memastikan tombol berada di bagian bawah
          ],
        ),
      ),
    );
  }
}


class ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 24,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.zero, // Menghilangkan padding default
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ),
    );
  }
}

