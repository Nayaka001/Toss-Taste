import 'package:flutter/material.dart';
import 'package:jualan/App/Toss/hasil.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/category.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/recipes_service.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/navbar.dart';

class TossTaste extends StatefulWidget {
  const TossTaste({super.key});

  @override
  State<TossTaste> createState() => _TossTaste();
}

class _TossTaste extends State<TossTaste> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<IngredientsCategory> _categories = []; // Menyimpan kategori
  Map<String, bool> _expandedCategories = {}; // Menyimpan status expand/collapse kategori
  final Set<String> _selectedItems = {}; // Menyimpan item yang dipilih

  @override
  void initState() {
    super.initState();
    ingredient(); // Memanggil menuPosts untuk mengambil data kategori saat pertama kali load
  }

  // Fungsi untuk mengambil data kategori dan subkategori
  Future<void> ingredient() async {
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
                              const Icon(Icons.search, color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Pantry Essentials, vegetables, & more...',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchText = value;
                                    });
                                  },
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.5),
                        child: const Text(
                          'Filtering By',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: _categories.map((category) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tampilkan Nama IngredientsCategory
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xFFE0F7FA),
                                  child: Text(
                                    category.categoryName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),

                                // Tampilkan Subkategori dan Item yang sesuai dengan pencarian
                                Column(
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
                                            _toggleItemSelection(item.namaItem); // Toggle item selection
                                          },
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      if (_selectedItems.isNotEmpty)
                        Flexible(
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                List<Map<String, dynamic>> filteredRecipes = [];
                                // Looping melalui kategori untuk menyaring item
                                for (var category in _categories) {
                                  for (var subcategory in category.subcategories) {
                                    for (var item in (subcategory.items ?? [])) {
                                      // Cek apakah item dipilih
                                      if (_selectedItems.contains(item.namaItem.toLowerCase())) {
                                        // Ambil resep terkait dari recipeItems (pastikan item memiliki field recipeItems)
                                        for (var recipe in item.recipeItems ?? []) {
                                          filteredRecipes.add({
                                            'item_name': item.namaItem, // Nama item
                                            'recipe_name': recipe.recipeName, // Nama resep
                                            'details': recipe.details, // Detail resep
                                          });
                                        }
                                      }
                                    }
                                  }
                                }

                                // Navigasi ke halaman hasil pencarian dengan mengirimkan filteredRecipes
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HasilRecipt(filteredRecipes: filteredRecipes),
                                  ),
                                );
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
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                                  ),
                                  const Text(
                                    'View Recipe >',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                                  ),
                                ],
                              ),
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
