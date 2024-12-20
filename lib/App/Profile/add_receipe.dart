import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/recipes_service.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';


class AddReceipe extends StatefulWidget {
  const AddReceipe({super.key});
  @override
  State<AddReceipe> createState() => _AddReceipe();
}

class _AddReceipe extends State<AddReceipe> {
  List<IngredientsCategory> _categories = [];
  List<int> _selectedItems = [];
  File? _selectedFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _servesController = TextEditingController();
  Future<int?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('user_id'); // Ambil user_id yang sudah disimpan saat login
  }

  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //
  //   if (result != null && result.files.single.path != null) {
  //     setState(() {
  //       _selectedFile = File(result.files.single.path!); // Simpan file terpilih
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('File yang dipilih: ${result.files.single.name}')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Tidak ada file yang dipilih')),
  //     );
  //   }
  // }

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
  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe name and description cannot be empty')),
      );
      return;
    }

    // Validasi apakah ada item yang dipilih
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    String token = await getToken();
    print("Token: $token");

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token is missing or invalid')),
      );
      return;
    }

    int? userId = await getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get user information')),
      );
      return;
    }

    final url = Uri.parse(addRecipes);
    final request = http.MultipartRequest('POST', url);

    // Konversi _selectedItems menjadi array langsung
    final itemsJson = _selectedItems.map((item) => item is int ? item : int.tryParse(item.toString()) ?? 0).toList();
    print('Items JSON: $itemsJson');

    // Iterasi untuk mengisi items secara terpisah
    for (int i = 0; i < itemsJson.length; i++) {
      request.fields['items[$i]'] = itemsJson[i].toString();
    }

    request.fields['recipe_name'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['waktu_pembuatan'] = _timeController.text;
    request.fields['serve'] = _servesController.text;
    request.fields['created_by'] = userId.toString();

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // Tambahkan file jika ada
    if (_selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _selectedFile!.path));
    }

    try {
      final response = await request.send();

      final responseStream = await response.stream.bytesToString();
      print('Response: ${response.statusCode} - $responseStream');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add recipe')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  void _onItemSelected(int itemId) {
    setState(() {
      // Mengelola pemilihan item
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }



  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId); // Hapus item jika sudah ada
      } else {
        _selectedItems.add(itemId); // Tambahkan item jika belum ada
      }
      print('Selected Items: $_selectedItems'); // Debugging selected items
    });
  }

  List<String> getSelectedItemNames() {
    // Mendapatkan nama item berdasarkan item_id yang dipilih
    List<String> selectedItemNames = [];
    for (int itemId in _selectedItems) {
      // Cari nama item berdasarkan item_id di _categories
      for (var category in _categories) {
        for (var subCategory in category.subcategories) {
          for (var item in subCategory.items) {
            if (item.item_id == itemId) {
              selectedItemNames.add(item.namaItem);
            }
          }
        }
      }
    }
    return selectedItemNames;
  }



  @override
  void initState() {
    super.initState();
    filterRecipes(); // Panggil fetchCategories saat widget dibangun pertama kali
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15, top: 41),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavbar(currentIndex: 3),
                        ),
                      );
                    },
                    icon: Image.asset(
                      'assets/images/close.png',
                      width: 22.85,
                      height: 22.85,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: const Center(
                      child: Text(
                        'Add Recipe',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 33),
              const Text(
                'Enter the title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Container(
                height: 41,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Tombol untuk membuka Bottom Sheet
              GestureDetector(
                onTap: () {
                  // Memanggil showModalBottomSheet saat tombol ditekan
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add ingredients',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: _categories.isEmpty
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView(
                                children: _categories.map((category) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                      Column(
                                        children: category.subcategories.map((subCategory) {
                                          return ExpansionTile(
                                            title: Text(
                                              subCategory.subcategoryName,
                                              style: const TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                            children: subCategory.items.map((item) {
                                              final isSelected = _selectedItems.contains(item.item_id);
                                              return ListTile(
                                                title: Text(item.namaItem),
                                                trailing: isSelected
                                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                                    : const Icon(Icons.check_circle_outline),
                                                onTap: () {
                                                  _toggleItemSelection(item.item_id);
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


                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 53,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBF3F0),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Icon(Icons.add, size: 28),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Menampilkan nama item yang dipilih
                  if (_selectedItems.isNotEmpty)
                    ...getSelectedItemNames().map((name) => Text(name)).toList(),
                  if (_selectedItems.isEmpty)
                    const Text('No items selected')
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                'Add time estimation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Container(
                height: 41,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Add serves amount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Container(
                height: 41,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _servesController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Add description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Container(
                height: 290,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black), // Border luar
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      expands: false,

                      decoration: const InputDecoration(
                        hintText: 'Enter a description',
                        hintStyle: TextStyle(color: Color.fromARGB(255, 104, 102, 102)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10.0, top: 9.0, right: 10.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                width: 126,
                height: 25,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color(0xFFCBF3F0)),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/attach.png',
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'File Attach',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    backgroundColor: WidgetStateProperty.all(const Color(0XFFFFBF69)),
                    minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, 34)),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'POST',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}