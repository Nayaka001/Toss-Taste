import 'package:flutter/material.dart';
import 'package:jualan/App/navbar.dart';

class DetailsCategory extends StatefulWidget {
  final String selectedCategory; // Parameter untuk kategori yang dipilih

  const DetailsCategory({super.key, required this.selectedCategory});

  @override
  State<DetailsCategory> createState() => _DetailsCategoryState();
}

class _DetailsCategoryState extends State<DetailsCategory> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // Map untuk melacak item mana yang sedang aktif
  late Map<String, bool> _selectedItems;

  final Map<String, String> _imagePaths = {
    'Protein': 'assets/images/tossprotein.png',
    'Karbohidrat': 'assets/images/tosscarbohydrate.png',
    'Spice': 'assets/images/tossspice.png',
    'Vegetables': 'assets/images/tossvegetables.png',
  };

  @override
  void initState() {
    super.initState();
    // Setel kategori aktif berdasarkan parameter
    _selectedItems = {
      'Protein': widget.selectedCategory == 'Protein',
      'Karbohidrat': widget.selectedCategory == 'Karbohidrat',
      'Spice': widget.selectedCategory == 'Spice',
      'Vegetables': widget.selectedCategory == 'Vegetables',
    };
  }

  void _toggleSelection(String item) {
    setState(() {
      _selectedItems = _selectedItems.map((key, value) {
        return MapEntry(key, key == item);
      });
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
                // Bagian header
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 76,
                            height: MediaQuery.of(context).size.height - 281,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.5, vertical: 13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildFilterItem('Protein'),
                                const SizedBox(height: 25),
                                _buildFilterItem('Karbohidrat'),
                                const SizedBox(height: 25),
                                _buildFilterItem('Spice'),
                                const SizedBox(height: 25),
                                _buildFilterItem('Vegetables'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height: MediaQuery.of(context).size.height - 281,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 1),
                            ),
                            child: ListView.builder(
                              itemCount: _selectedItems.entries
                                  .where((entry) => entry.value)
                                  .length, // Hanya bahan dari kategori aktif
                              itemBuilder: (context, index) {
                                String activeCategory = _selectedItems.entries
                                    .firstWhere((entry) => entry.value)
                                    .key; // Ambil kategori aktif
                                return ListTile(
                                  title: Text(
                                      "Bahan dari $activeCategory"), // Ubah dengan data bahan
                                );
                              },
                            ),
                          ),
                        ],
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
    return GestureDetector(
      onTap: () => _toggleSelection(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        width: 61,
        height: 61,
        decoration: BoxDecoration(
          color: _selectedItems[label]!
              ? const Color(0XFFCBF3F0)
              : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 41,
              decoration: BoxDecoration(
                color: const Color(0XFFFFBF69), // Warna oren
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
