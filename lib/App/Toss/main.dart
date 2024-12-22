import 'dart:convert'; 

import 'package:flutter/material.dart';
import 'package:jualan/App/Toss/details_category.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/category.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/recipes_service.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/navbar.dart';
import 'package:http/http.dart' as http;

class TossTaste extends StatefulWidget {
  const TossTaste({super.key});

  @override
  State<TossTaste> createState() => _TossTaste();
}

class _TossTaste extends State<TossTaste> {
  final TextEditingController _searchController = TextEditingController();

  // Map untuk melacak item mana yang sedang aktif
  Map<String, bool> _selectedItems = {
    'Protein': false,
    'Carbohydrates': false,
    'Spices': false,
    'Vegetables': false,
    'Fruits': false,
    'Oils and Fats': false,
    'Dairy Processing': false,
    'Flour & Baking Essentials': false,
    'Others': false,
  };

  // Gambar kategori
  final Map<String, String> _imagePaths = {
    'Protein': 'assets/images/protein_category.png',
    'Carbohydrates': 'assets/images/carbohydrates_category.png',
    'Spices': 'assets/images/spices_category.png',
    'Vegetables': 'assets/images/vegetables_category.png',
    'Fruits': 'assets/images/fruits_category.png',
    'Oils and Fats': 'assets/images/oils_category.png',
    'Dairy Processing': 'assets/images/dairy_category.png',
    'Flour & Baking Essentials': 'assets/images/flour_category.png',
    'Others': 'assets/images/others_category.png',
  };

  void _toggleSelection(String item) {
    setState(() {
      // Memilih kategori
      _selectedItems = _selectedItems.map((key, value) {
        return MapEntry(key, key == item);
      });
    });

    // Navigasi ke halaman berdasarkan kategori
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsCategory(selectedCategory: '',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header bagian atas
              Container(
                margin: const EdgeInsets.only(left: 22, right: 22, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavbar(currentIndex: 0),
                          ),
                        );
                      },
                      icon: Image.asset('assets/images/back.png'),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Cook With Pantry',
                        style:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 17),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black54),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.black54),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Pantry Essentials, vegetables, & more...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 29.0),
                  ],
                ),
              ),
              // Kontainer untuk bagian kategori
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 1.0)),
                  color: Color(0XFFCBF3F0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Filtering By',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                        childAspectRatio: 129 / 166.11,
                      ),
                      itemCount: _selectedItems.keys.length,
                      itemBuilder: (context, index) {
                        String key = _selectedItems.keys.elementAt(index);
                        return _buildCategoryButton(key);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk button kategori
Widget _buildCategoryButton(String label) {
  return GestureDetector(
    onTap: () => _toggleSelection(label),
    child: Column(
      children: [
        Container(
          width: 129,
          height: 166.11,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0XFFCBF3F0),
            image: DecorationImage(
              image: AssetImage(_imagePaths[label]!),
              fit: BoxFit.contain,
            ),
            border: Border.all(
              color: _selectedItems[label]! ? Colors.orange : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

}
