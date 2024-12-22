import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jualan/App/detail.dart';
import 'package:jualan/App/models/favorite.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jualan/App/models/recipes.dart';  // Import model Recipe

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Favorite> favorites = []; // List untuk menyimpan data Favorite
  int userId = 0; // ID pengguna yang diperoleh dari SharedPreferences

  @override
  void initState() {
    super.initState();
    fetchUserIdAndFavorites(); // Ambil user ID dan data favorites
  }

  /// Mendapatkan user ID dari SharedPreferences dan memuat data favorites
  Future<void> fetchUserIdAndFavorites() async {
    final id = await getUserId();
    setState(() {
      userId = id;
    });
    fetchFavorites();
  }

  /// Mendapatkan user ID dari SharedPreferences
  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final id = pref.getInt('user_id') ?? 0;
    return id;
  }

  /// Mengambil data favorites dari API berdasarkan user ID
  Future<void> fetchFavorites() async {
    if (userId == 0) return; // Tidak memuat jika user ID tidak valid
    final url = Uri.parse('http://10.0.2.2:8000/api/favorites/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        favorites = (data['data'] as List)
            .map((item) {
          final recipe = Recipes.fromJson(item['recipe']); // Mengambil data recipe
          return Favorite.fromJson(item)..recipe = recipe; // Menambahkan recipe pada Favorite
        })
            .toList();
      });
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  /// Menghapus data favorite berdasarkan ID
  Future<void> removeFavorite(int favoriteId) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/favorites/delete/$favoriteId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        favorites.removeWhere((fav) => fav.favId == favoriteId);
      });
    } else {
      throw Exception('Failed to delete favorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: userId == 0
          ? const Center(child: CircularProgressIndicator()) // Menunggu user ID
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index]; // Objek Favorite
          final recipe = favorite.recipe; // Objek Recipe dari Favorite

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.recipe_name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(recipe.description),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(
                                recipeId: recipe.recipeId,
                              ),
                            ),
                          );
                        },
                        child: const Text('Baca'),
                      ),
                      IconButton(
                        onPressed: () => removeFavorite(favorite.favId),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
