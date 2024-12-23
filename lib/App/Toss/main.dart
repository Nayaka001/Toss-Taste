import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jualan/App/Toss/hasil.dart';
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
  String _searchText = '';
  List<IngredientsCategory> _categories = []; // Menyimpan kategori
  final Set<String> _selectedItems = {}; // Menyimpan item yang dipilih

  @override
  void initState() {
    super.initState();
    filterRecipes();
    List<String> queries = _searchController.text.split(',').map((e) => e.trim()).toList();
    searchRecipes(queries);
  }
  Future<List<Map<String, dynamic>>> searchRecipes(List<String> queries) async {
    String token = await getToken();
    // Menggunakan query parameters untuk GET request
    final uri = Uri.parse(search).replace(queryParameters: {'queries': queries.join(',')});

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Debugging response
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return List<Map<String, dynamic>>.from(responseBody.map((item) => item as Map<String, dynamic>));
    } else {
      throw Exception('Failed to fetch recipes: ${response.statusCode}');
    }
  }
  Future<void> fetchCategories() async {
    try {
      // Mendapatkan token (jika diperlukan untuk autentikasi)
      String token = await getToken();

      // Membuat permintaan GET ke API untuk mengambil kategori
      final uri = Uri.parse(hasilResep); // Ganti dengan URL endpoint API Anda
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan header Authorization jika diperlukan
        },
      );

      // Debugging respons
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Cek status respons
      if (response.statusCode == 200) {
        // Decode respons JSON menjadi List<IngredientsCategory> atau struktur yang sesuai
        List<dynamic> responseBody = json.decode(response.body);

        // Ubah data respons menjadi struktur kategori yang diinginkan
        setState(() {
          _categories = responseBody.map((data) => IngredientsCategory.fromJson(data)).toList();
        });
      } else {
        print("Error fetching categories: ${response.statusCode}");
        print("Message: ${response.body}");
      }
    } catch (e) {
      // Tangani exception yang terjadi
      print("Exception during fetchCategories: $e");
    }
  }


  Future<void> filterRecipes() async {
    try {
      ApiResponse response = await getIngredients();

      if (response.error == null) {

        if (response.data is List<IngredientsCategory>) {
          setState(() {
            _categories = response.data as List<IngredientsCategory>;
          });
        } else {
          print("Invalid response structure");
          print("Response data: ${response.data}");
          print("Response data type: ${response.data.runtimeType}");

        }
      } else if (response.error == unauthorized) {
        logout().then((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
          );
        });
      }
    } catch (e) {
      print("Error fetching ingredients: $e");
    }
  }





  // Fungsi untuk mengubah status pilihan item
  void _toggleItemSelection(String namaItem) {
    setState(() {
      if (_selectedItems.contains(namaItem)) {
        _selectedItems.remove(namaItem); // Hapus item jika tidak terpilih
      } else {
        _selectedItems.add(namaItem); // Tambahkan item jika terpilih
      }
    });
  }

  // Fungsi untuk menyaring kategori, subkategori, dan item sesuai pencarian
  bool _isItemMatched(String namaItem) {
    return namaItem.toLowerCase().contains(_searchText.toLowerCase());
  }
  void hasilRecipes() {
    List<Map<String, dynamic>> filteredRecipes = [];

    for (var category in _categories) {
      for (var subcategory in category.subcategories ?? []) {
        for (var item in subcategory.items ?? []) {
          if (_selectedItems.contains(item['item_name'].toLowerCase())) {
            for (var recipe in item['recipeItems'] ?? []) {
              filteredRecipes.add({
                'item_name': item['item_name'],
                'recipe_name': recipe['recipeName'],
                'details': recipe['details'],
              });
            }
          }
        }
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    double marginModal = MediaQuery.of(context).size.width - 42;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 22, right: 22, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomNavbar(currentIndex: 0),
                            ),
                          );
                        },
                        icon: Image.asset('assets/images/back.png'),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Cook With Pantry',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                              IconButton(
                                icon: const Icon(Icons.search, color: Colors.black54),
                                onPressed: () async {
                                  // Pastikan teks pencarian tidak kosong
                                  if (_searchController.text.isEmpty) {
                                    return; // Tidak melakukan pencarian jika teks kosong
                                  }

                                  // Pisahkan teks berdasarkan koma
                                  final queries = _searchController.text.split(',').map((e) => e.trim()).toList();

                                  // Panggil searchRecipes untuk mendapatkan hasil pencarian
                                  try {
                                    List<Map<String, dynamic>> results = await searchRecipes(queries);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HasilRecipt(
                                          filteredQueries: queries,
                                          filteredRecipes: results, // Hasil pencarian
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    print("Error during search nii: $e"); // Tambahkan pengecekan lebih lanjut
                                  }
                                },
                              ),

                              const SizedBox(width: 8),
                              // TextField untuk input pencarian
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Pantry Essentials, vegetables, & more...',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.5),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 207,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(width: 1.0)),
                    color: Color(0XFFCBF3F0),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.5),
                            child: const Text(
                              'Filtering By',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: _categories.map((category) {
                                return ExpansionTile(
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFFFBF69),
                                      border: Border.all(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      category.categoryName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  children: category.subcategories.map((subCategory) {
                                    return ExpansionTile(
                                      title: Text(
                                        subCategory.subcategoryName,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      children: (subCategory.items.where((item) => _isItemMatched(item.namaItem)) ?? [])
                                          .map((item) {
                                        final isSelected = _selectedItems.contains(item.namaItem);
                                        return ListTile(
                                          title: Text(item.namaItem),
                                          trailing: isSelected
                                              ? const Icon(Icons.check_circle, color: Colors.green)
                                              : const Icon(Icons.check_circle_outline),
                                          onTap: () {
                                            _toggleItemSelection(item.namaItem);
                                          },
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedItems.isNotEmpty)
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: ElevatedButton(
                            onPressed: () {
                              List<Map<String, dynamic>> filteredRecipes = [];
                              print("Selected Items: $_selectedItems"); // Debugging: Cek nilai _selectedItems

                              // Loop untuk memfilter resep berdasarkan _selectedItems
                              for (var category in _categories) {
                                print("Processing Category: ${category.categoryName}"); // Debugging: Cek kategori
                                for (var subcategory in (category.subcategories ?? [])) {
                                  print("Processing Subcategory: ${subcategory.subcategoryName}"); // Debugging: Cek subkategori
                                  for (var item in (subcategory.items ?? [])) {
                                    print("Processing item: ${item.namaItem}"); // Debugging: Cek item yang sedang diproses

                                    // Pastikan membandingkan nama item dengan pilihan yang sudah di-trim dan lowercased
                                    bool isItemMatched = _selectedItems.any((selectedItem) =>
                                    selectedItem.toLowerCase().trim() == item.namaItem.toLowerCase().trim());
                                    print("Item match check: $isItemMatched");

                                    if (isItemMatched) {
                                      print("Item matched: ${item.namaItem}");
                                      print("Item recipeItems: ${item.recipeItems}"); // Debugging: Cek recipeItems

                                      // Pastikan recipeItems ada dan tidak kosong
                                      if (item.recipeItems != null && item.recipeItems.isNotEmpty) {
                                        for (var recipe in item.recipeItems) {
                                          // Debugging: Cek setiap resep yang ditambahkan ke filteredRecipes
                                          print("Adding recipe: ${recipe.recipeName}");
                                          filteredRecipes.add({
                                            'item_name': item.namaItem,
                                            'recipe_name': recipe.recipeName,
                                            'details': recipe.details,
                                          });
                                        }
                                      } else {
                                        print("No recipes available for ${item.namaItem}");
                                      }
                                    }
                                  }
                                }
                              }

                              // Debugging: Cek hasil filter resep
                              print("Filtered Recipes: $filteredRecipes");

                              // Navigasi jika ada resep yang cocok
                              if (filteredRecipes.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HasilRecipt(
                                      filteredRecipes: filteredRecipes,
                                      filteredQueries: _selectedItems.toList(),
                                    ),
                                  ),
                                );
                              } else {
                                // Tampilkan pesan jika tidak ada resep
                                print("No recipes found.");
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("No Recipes Found"),
                                    content: Text("No recipes match your selected items."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2EC4B6),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1.0, color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Bahan: ${_selectedItems.length}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  'View Recipe >',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}