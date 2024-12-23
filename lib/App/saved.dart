import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jualan/App/detail.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/favorite.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jualan/App/models/recipes.dart';  // Import model Recipe

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  List<dynamic> likes = []; // Menyimpan daftar likes
  int userId = 0; // Mendeklarasikan userId

  @override
  void initState() {
    super.initState();
    fetchUserId(); // Memuat userId saat screen dibuka
  }

  /// Mengambil userId dari SharedPreferences dan memanggil fetchLikes
  Future<void> fetchUserId() async {
    final id = await getUserId();  // Ambil userId
    setState(() {
      userId = id;  // Simpan userId
    });
    fetchLikes();  // Memanggil fetchLikes setelah userId tersedia
  }

  /// Mendapatkan user ID dari SharedPreferences
  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('user_id') ?? 0;  // Mengambil userId atau default 0
  }

  /// Mengambil data like dari API
  Future<void> fetchLikes() async {
    if (userId == 0) return;

    try {
      final likeUrl = await getLike(userId); // Ganti nama variabel
      final response = await http.get(Uri.parse(likeUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched favourites: $data");
        setState(() {
          likes = data['data'] ?? []; // Simpan daftar favorit
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
          'Likes', // Mengubah judul dari "Favourites" menjadi "Likes"
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: likes.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Menunggu data
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 150 / 190, // Aspect ratio for the cards
          ),
          itemBuilder: (context, index) {
            if (index >= likes.length || likes[index]['recipes'] == null) {
              return const SizedBox(); // Tampilkan placeholder jika data tidak valid
            }
            final recipe = likes[index]['recipes'];
            final imageName = recipe['image']; // Nama file gambar dari API
            final imagePath = 'assets/images/$imageName';
            return LikesCard(
              recipe_name: recipe['recipe_name'] ?? 'Unknown Recipe',
              waktu_pembuatan: recipe['waktu_pembuatan'] ?? 'Unknown Time',
              imageUrl: imagePath,
            );
          },
        ),
      ),
    );
  }
}

class LikesCard extends StatelessWidget {
  final String recipe_name;
  final String waktu_pembuatan;
  final String imageUrl;

  const LikesCard({
    super.key,
    required this.recipe_name,
    required this.waktu_pembuatan,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Lebar kartu
      height: 190, // Tinggi kartu
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
          ],
        ),
      ),
    );
  }
}

