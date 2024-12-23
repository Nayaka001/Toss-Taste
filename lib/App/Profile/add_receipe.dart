import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/Profile/profile.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/recipes_service.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
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
  Duration _cookingDuration = Duration(hours: 0, minutes: 0);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _servesController = TextEditingController();
  Future<int?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('user_id'); // Ambil user_id yang sudah disimpan saat login
  }

  Future<void> _pickImage() async {
    if (await Permission.storage.request().isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );

        if (result != null && result.files.single.path != null) {
          setState(() {
            _selectedFile = File(result.files.single.path!);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File yang dipilih: ${result.files.single.name}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada file yang dipilih')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      if (await Permission.storage.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buka pengaturan untuk memberikan izin')),
        );
        openAppSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required')),
        );
      }
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
  Future<void> _submitForm() async {
    // Validasi Input
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      _showSnackbar('Recipe name and description cannot be empty');
      return;
    }
    // Hilangkan verifikasi file
    // if (_selectedFile == null) {
    //   _showSnackbar('Please select a file first');
    //   return;
    // }
    if (_selectedItems.isEmpty) {
      _showSnackbar('Please select at least one item');
      return;
    }

    // Ambil Token
    String token = await getToken();
    if (token.isEmpty) {
      _showSnackbar('Token is missing or invalid');
      return;
    }

    // Ambil User ID
    int? userId = await getUserId();
    if (userId == null) {
      _showSnackbar('Failed to get user information');
      return;
    }

    // URL untuk mengirim data
    final url = Uri.parse(addRecipes);

    // Membuat Request Multipart
    final request = http.MultipartRequest('POST', url)
      ..fields['recipe_name'] = _titleController.text
      ..fields['description'] = _descriptionController.text
      ..fields['waktu_pembuatan'] =
          '${_cookingDuration.inHours}:${_cookingDuration.inMinutes.remainder(60)}'
      ..fields['serve'] = _servesController.text
      ..fields['created_by'] = userId.toString()
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    // Tambahkan File Gambar jika Ada
    if (_selectedFile != null) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _selectedFile!.path,
        filename: fileName,
      ));
    }

    // Tambahkan Items
    for (int i = 0; i < _selectedItems.length; i++) {
      final item = _selectedItems[i];
      request.fields['items[$i]'] = item.toString();
    }

    // Kirim Request
    try {
      final response = await request.send();
      final responseStream = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        _showSnackbar('Recipe added successfully');
        // Navigasi ke halaman lain atau reset form
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  const BottomNavbar(currentIndex: 3,)),
        );
      } else {
        print('Response: ${response.statusCode} - $responseStream');
        _showSnackbar('Failed to add recipe');
      }
    } catch (e) {
      _showSnackbar('Error: $e');
    }
  }



// Helper untuk Menampilkan Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                child: InkWell(
                  onTap: () async {
                    // Menampilkan Bottom Sheet dengan CupertinoTimerPicker untuk memilih durasi
                    Duration? selectedDuration = await showModalBottomSheet<Duration>(
                      context: context,
                      builder: (BuildContext context) {
                        Duration tempDuration = _cookingDuration;
                        return SizedBox(
                          height: 250,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  'Pilih estimasi waktu memasak',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CupertinoTimerPicker(
                                  mode: CupertinoTimerPickerMode.hm,
                                  initialTimerDuration: _cookingDuration,
                                  onTimerDurationChanged: (Duration newDuration) {
                                    tempDuration = newDuration;
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(tempDuration);
                                },
                                child: const Text('Simpan'),
                              ),
                            ],
                          ),
                        );
                      },
                    );

                    if (selectedDuration != null) {
                      setState(() {
                        _cookingDuration = selectedDuration;
                        _timeController.text =
                            '${_cookingDuration.inHours} jam ${_cookingDuration.inMinutes.remainder(60)} menit';
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Text(
                      _timeController.text.isNotEmpty
                          ? _timeController.text
                          : 'Select Duration',
                      style: TextStyle(
                        fontSize: 16,
                        color: _timeController.text.isNotEmpty ? Colors.black : Colors.grey,
                      ),
                    ),
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
                    backgroundColor: MaterialStateProperty.all(const Color(0xFFCBF3F0)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: _pickImage,
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
              const SizedBox(height: 10),
              _selectedFile != null
                  ? Image.file(
                _selectedFile!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : const Text('No image selected'),
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
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(const Color(0XFFFFBF69)),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 34)),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'POST',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
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