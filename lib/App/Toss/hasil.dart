import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/detail.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/recipes.dart';  // Pastikan model Recipe sudah didefinisikan dengan benar
import 'package:jualan/App/models/recipes_service.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/register.dart';

class HasilRecipt extends StatefulWidget {
  final List<String> filteredQueries;
  final List<Map<String, dynamic>> filteredRecipes;

  const HasilRecipt({
    super.key,
    required this.filteredQueries,
    required this.filteredRecipes,
  });

  @override
  _HasilReciptState createState() => _HasilReciptState();
}

class _HasilReciptState extends State<HasilRecipt> {
  List<Map<String, dynamic>> _menuList = [];

  @override
  void initState() {
    super.initState();
    _menuList = widget.filteredRecipes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Container(
              margin: const EdgeInsets.only(left: 19.96),
              child: const Text(
                'Hasil Pencarian atau Filter',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 11),

            // Menampilkan hasil filter atau pesan "No recipes found"
            if (_menuList.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 19.96),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _menuList.map((recipe) {
                      return RecipeCard(
                        recipeName: recipe['recipe_name'] ?? 'Recipe Name',
                        recipeId: recipe['recipe_id'] ?? 0, // Gunakan nilai default 0
                        waktu_pembuatan: recipe['waktu_pembuatan'] ?? 'Unknown',
                      );
                    }).toList(),
                  ),
                ),
              )
            else
              const Center(
                child: Text(
                  "No recipes found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}





class RecipeCard extends StatelessWidget {
  final String recipeName;
  final int recipeId;
  final String waktu_pembuatan;

  const RecipeCard({
    Key? key,
    required this.recipeName,
    required this.recipeId,
    required this.waktu_pembuatan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.only(left: 9, top: 6, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar default
            Image.asset(
              'assets/images/imgayam.png',
              width: double.infinity,
              height: 69,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 7),

            // Nama resep
            Text(
              recipeName,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Menghindari overflow
            ),

            // Waktu pembuatan
            Text(
              waktu_pembuatan,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Menghindari overflow
            ),
            const SizedBox(height: 9),

            // Tombol aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionButton(
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
                ActionButton(
                  label: 'Save',
                  backgroundColor: Colors.yellow,
                  onPressed: () {
                    // Aksi untuk menyimpan
                  },
                ),
              ],
            ),
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

// //hasil dari filter
// Container(
//   margin: const EdgeInsets.only(left: 19.96),
//   child: SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Row(
//       children: widget.filteredQueries
//           .map((recipeName) => RecipeCard(recipeName: recipeName))
//           .toList(),
//     ),
//   ),
// ),
// hasil dari seraching
