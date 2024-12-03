import 'package:flutter/material.dart';
import 'package:jualan/App/navbar.dart';

class TossTaste extends StatefulWidget {
  const TossTaste({super.key});

  @override
  State<TossTaste> createState() => _TossTaste();
}

class _TossTaste extends State<TossTaste> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final Map<String, bool> _selectedItems = {
    'Protein': false,
    'Karbohidrat': false,
    'Spice': false,
    'Vegetables': false,
  };

  final Map<String, String> _imagePaths = {
    'Protein': 'assets/images/tossprotein.png',
    'Karbohidrat': 'assets/images/tossprotein.png',
    'Spice': 'assets/images/tossspice.png',
  };

  final Map<String, bool> _selectedCategories = {
    'Chicken': false,
    'Beef': false,
    'Duck': false,
    'Pork': false,
    'Garlic' : false
  };


  bool isChickenChecked = false;
  bool isBeefChecked = false;
  bool isDuckChecked = false;
  bool isGarlicChecked = false;

  final Set<String> _selectedIngredients = Set<String>();

  int _getSelectedCount() {
    return _selectedCategories.values.where((isSelected) => isSelected).length;
  }

  void _toggleSelection(String item) {
    setState(() {
      if (_selectedItems[item] == true) {
        _selectedItems[item] = false;
        // Hapus item dari _selectedIngredients jika bukan kategori utama
        if (!_selectedCategories.containsKey(item)) {
          _selectedIngredients.remove(item);
        }
      } else {
        _selectedItems[item] = true;
        // Tambahkan item ke _selectedIngredients jika bukan kategori utama
        if (!_selectedCategories.containsKey(item)) {
          _selectedIngredients.add(item);
        }
      }

      // Periksa jika subkategori Protein atau Spice aktif
      if (item == 'Protein') {
        bool isAnySubCategorySelected = _selectedCategories.containsValue(true);
        _selectedItems['Protein'] = isAnySubCategorySelected;
        // Update _selectedIngredients jika ada subkategori Protein yang aktif
        if (isAnySubCategorySelected) {
          _selectedIngredients.add('Protein');
        } else {
          _selectedIngredients.remove('Protein');
        }
      } else if (item == 'Spice') {
        bool isAnySubCategorySelected = _selectedCategories['Garlic'] ?? false;
        _selectedItems['Spice'] = isAnySubCategorySelected;
        // Update _selectedIngredients jika Garlic dipilih
        if (isAnySubCategorySelected) {
          _selectedIngredients.add('Spice');
        } else {
          _selectedIngredients.remove('Spice');
        }
      }
    });
  }

  String? selectedCategory;

  void _toggleCategorySelection(String category) {
    setState(() {
      // Toggle pilihan untuk kategori
      _selectedCategories[category] = !_selectedCategories[category]!;

      // Tambah atau hapus kategori dari selectedIngredients
      if (_selectedCategories[category]!) {
        _selectedIngredients.add(category);
      } else {
        _selectedIngredients.remove(category);
      }

      if (_selectedCategories[category]!) {
        selectedCategory = category; // Set kategori aktif
      } else {
        selectedCategory = null; // Hapus jika tidak ada kategori aktif
      }

      // Update status kategori utama berdasarkan apakah subkategori ada yang dipilih
      bool isAnySubCategorySelected = _selectedCategories.containsValue(true);

      // Update status 'Protein' dan 'Spice' berdasarkan subkategori yang dipilih
      if (category == 'Protein') {
        _selectedItems['Protein'] = isAnySubCategorySelected;
      } else if (category == 'Spice') {
        _selectedItems['Spice'] = isAnySubCategorySelected;
      }
    });
  }





  @override
  Widget build(BuildContext context) {
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
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 76,
                              height: MediaQuery.of(context).size.height - 281,
                              padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 13),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(width: 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildFilterItem('Protein'),
                                  const SizedBox(height: 25,),
                                  _buildFilterItem('Karbohidrat'),
                                  const SizedBox(height: 25,),
                                  _buildFilterItem('Spice'),
                                  const SizedBox(height: 25,),
                                  _buildFilterItem('Vegetables'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 7),
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              height: MediaQuery.of(context).size.height - 281,
                              padding: const EdgeInsets.symmetric(horizontal: 9.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('0/40 Ingredients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                  IntrinsicHeight(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: selectedCategory == 'Chicken' || selectedCategory == 'Beef' || selectedCategory == 'Duck'
                                              ? const Color(0XFFCBF3F0) // Warna biru jika Garlic aktif
                                              : Colors.white, // Warna putih untuk default atau Duck
                                        ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Protein', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                                          Row(
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _toggleCategorySelection('Chicken');
                                                      setState(() {
                                                      isChickenChecked = !isChickenChecked
                                                      ;});
                                                      },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor: const Color(0XFFEBEAEA),
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                        side: const BorderSide(color: Colors.black, width: 1),
                                                      ),
                                                      splashFactory: NoSplash.splashFactory,
                                                    ),
                                                    child: const Text(
                                                      'Chicken',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isChickenChecked)  // Jika isChecked true, tampilkan positioned
                                                    Positioned(
                                                      bottom: -5,
                                                      right: -5,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.green,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _toggleCategorySelection('Beef');
                                                      setState(() {
                                                        isBeefChecked = !isBeefChecked
                                                        ;});
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor: const Color(0XFFEBEAEA),
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                        side: const BorderSide(color: Colors.black, width: 1),
                                                      ),
                                                      splashFactory: NoSplash.splashFactory,
                                                    ),
                                                    child: const Text(
                                                      'Beef',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isBeefChecked)  // Jika isChecked true, tampilkan positioned
                                                    Positioned(
                                                      bottom: -5,
                                                      right: -5,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.green,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _toggleCategorySelection('Duck');
                                                      setState(() {
                                                        isDuckChecked = !isDuckChecked
                                                        ;});
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor: const Color(0XFFEBEAEA),
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                        side: const BorderSide(color: Colors.black, width: 1),
                                                      ),
                                                      splashFactory: NoSplash.splashFactory,
                                                    ),
                                                    child: const Text(
                                                      'Duck',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isDuckChecked)  // Jika isChecked true, tampilkan positioned
                                                    Positioned(
                                                      bottom: -5,
                                                      right: -5,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.green,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                  // Subkateogri Spice
                                  const SizedBox(height: 8,),
                                  IntrinsicHeight(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: selectedCategory == 'Garlic' || selectedCategory == 'Cabbage'
                                              ? const Color(0XFFCBF3F0) // Warna biru jika Garlic aktif
                                              : Colors.white, // Warna putih untuk default atau Duck
                                        ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Spice',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _toggleCategorySelection('Garlic');  // Pilih subkategori Garlic
                                                      setState(() {
                                                        // Perbarui status pilihan subkategori Garlic
                                                        isGarlicChecked = !isGarlicChecked;
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor: const Color(0XFFEBEAEA),
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                        side: const BorderSide(color: Colors.black, width: 1),
                                                      ),
                                                      splashFactory: NoSplash.splashFactory,
                                                    ),
                                                    child: const Text(
                                                      'Garlic',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  // Tampilkan ikon ceklis jika Garlic dipilih
                                                  if (isGarlicChecked)
                                                    Positioned(
                                                      bottom: -5,
                                                      right: -5,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.green,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
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
                      if (_selectedIngredients.isNotEmpty)
                        Flexible(

                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate or perform action with selected ingredients
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Total Bahan: ${_selectedIngredients.length}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
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
  Widget _buildFilterItem(String label) {
    bool isActive = _selectedItems[label] ?? false;

    // Periksa apakah subkategori aktif untuk mengaktifkan 'Protein'
    if (label == 'Spice' && _selectedCategories['Garlic']!) {
      isActive = true;
    }

    if (label == 'Protein' &&
        (_selectedCategories['Chicken']! ||
            _selectedCategories['Beef']! ||
            _selectedCategories['Duck']! ||
            _selectedCategories['Pork']!)) {
      isActive = true;
    }

    return GestureDetector(
      onTap: () {
        if (label == 'Protein' && (_selectedCategories['Chicken']! ||
            _selectedCategories['Beef']! ||
            _selectedCategories['Duck']! ||
            _selectedCategories['Pork']!)) {
          // Biarkan Protein bisa dipilih hanya jika ada subkategori Protein yang aktif
          _toggleSelection(label);
        } else if (label == 'Spice' && _selectedCategories['Garlic']!) {
          // Biarkan Spice bisa dipilih hanya jika Garlic aktif
          _toggleSelection(label);
        } else if (label != 'Protein' && label != 'Spice') {
          _toggleSelection(label);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        width: 61,
        height: 61,
        decoration: BoxDecoration(
          color: isActive ? const Color(0XFFCBF3F0) : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 41,
              decoration: BoxDecoration(
                color: const Color(0XFFFFBF69),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Image.asset(
                  _imagePaths[label] ?? 'assets/images/tossprotein.png',
                  width: MediaQuery.of(context).size.width,
                  height: 24,
                ),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
