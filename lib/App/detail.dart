import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/home_screen.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/models/category.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/detail_recipe.dart';
import 'package:jualan/App/models/review.dart';
import 'package:jualan/App/models/saved_service.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/navbar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Detail extends StatefulWidget {
  final int recipeId;

  const Detail({super.key, required this.recipeId});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  late Future<RecipeDetail> recipeDetail;

  Future<RecipeDetail> fetchRecipeDetail(int recipeId) async {
    final url = getRecipeURL(recipeId);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return RecipeDetail.fromJson(data);
    } else {
      throw Exception('Failed to load recipe detail');
    }
  }

  Future<void> _likeRecipe() async {
    final String apiUrl = 'http://10.0.2.2:8000/api/likes'; // Ganti dengan URL API Anda

    try {
      // Ambil user_id terlebih dahulu
      int userId = await getUserId();

      // Membuat data untuk dikirim
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'recipe_id': widget.recipeId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Success: ${data['message']}');
      } else {
        print('Failed to like recipe');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    recipeDetail = fetchRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RecipeDetail>(
        future: recipeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final recipe = snapshot.data!;

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 26, right: 26, top: 41),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomNavbar(
                                  currentIndex: 0,
                                ),
                              ),
                            );
                          },
                          icon: Image.asset(
                            'assets/images/close.png',
                            width: 22.85,
                            height: 22.85,
                          ),
                        ),
                        const SizedBox(width: 67),
                        const Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 200,
                        child: Image.asset(
                          'assets/images/${recipe.image}', // Gambar menggunakan data dari model
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            width: 45,
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                _likeRecipe(); // Panggil fungsi untuk mengirim permintaan API
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(
                                Icons.thumb_up_alt_outlined,
                                size: 25,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            width: 144,
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                showModalFirst(context, widget.recipeId, recipe);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.only(left: 9, right: 8),
                              ),
                              child: const Text(
                                'Rate & Review',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            width: 133,
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                showReportModal(context); // Memanggil fungsi modal
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.only(left: 9, right: 8),
                              ),
                              child: const Text(
                                'Report',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.recipeName, // Nama resep dari model
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  'assets/images/jam.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                '${recipe.waktuPembuatan} min',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 9,),

                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset('assets/images/harvest.png', fit: BoxFit.cover,)
                              ),
                              const SizedBox(width: 7,),
                              Text('${recipe.totalItems} ingredient(s)', style: const TextStyle(
                                  fontSize: 16
                              ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9,),
                          Row(
                            children: [
                              SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset('assets/images/serving.png', fit: BoxFit.cover,)
                              ),
                              const SizedBox(width: 7,),
                              Text('${recipe.serve} serve(s)', style: const TextStyle(
                                  fontSize: 16
                              ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9,),
                          Row(
                            children: [
                              SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset('assets/images/fav.png', fit: BoxFit.cover,)
                              ),
                              const SizedBox(width: 7,),
                              Text(recipe.averageRating.toStringAsFixed(1), style: const TextStyle(
                                  fontSize: 16
                              ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text(recipe.description)
                          // Tambahkan elemen UI lainnya menggunakan data dari model
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}


void showModalFirst(BuildContext context, int recipeId, RecipeDetail recipe) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.75,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 120,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 5, 5, 5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 40,
                          color: Colors.amber,
                        ),
                        Icon(
                          Icons.star_outline,
                          size: 40,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: recipe.averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const TextSpan(
                            text: '/5',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        recipe.comments.length, // Menggunakan jumlah komentar dari recipe
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.comments[index].user.name, // Nama user
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: List.generate(
                                        5,
                                            (starIndex) => Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 25,
                                                color: starIndex < recipe.comments[index].rating
                                                    ? Colors.amber
                                                    : Colors.grey[300],
                                              ),
                                              const Icon(
                                                Icons.star_outline,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      recipe.comments[index].comment, // Komentar pengguna
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onTap: () {
                    Navigator.pop(context); // Tutup modal pertama
                    showModalSecond(context, recipeId); // Buka modal kedua
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Left a review',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: const Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}





void showModalSecond(BuildContext context, int recipeId) {
  int selectedRating = 0; // Menyimpan rating yang dipilih
  TextEditingController commentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (BuildContext context) {
      double height = MediaQuery.of(context).size.height * 0.55;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Drag Indicator
                    Container(
                      width: 120,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 5, 5, 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'How Would You Rate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ayam Bawang', // Ganti dengan nama resep dinamis
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Rating Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                            (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1; // Update rating
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Lapisan Outline (Selalu hitam)
                              const Icon(
                                Icons.star_border,
                                color: Colors.black,
                                size: 40,
                              ),
                              if (index < selectedRating)
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 26,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Comment Section
                    TextField(
                      controller: commentController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Leave a review',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Handle submit action
                          await FavoritesService.submitReview(
                            recipeId: recipeId, // Mengakses recipeId dari parameter
                            rating: selectedRating,
                            comment: commentController.text,
                          );
                          Navigator.pop(context); // Close modal setelah submit
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFBF69),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: Size(double.infinity, 30),
                        ),
                        child: const Text(
                          'SEND',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showReportModal(BuildContext context) {
  String? selectedReason; // Variabel untuk menyimpan alasan yang dipilih
  TextEditingController explanationController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Report Resep',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Memperbesar modal
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Pilih alasan pelaporan:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Radio Buttons
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Spam atau Iklan'),
                          value: 'spam',
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile<String>(
                          title: const Text('Konten Tidak Pantas'),
                          value: 'inappropriate',
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile<String>(
                          title: const Text('Melanggar Hak Cipta'),
                          value: 'copyright',
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile<String>(
                          title: const Text('Informasi Tidak Akurat'),
                          value: 'inaccurate',
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile<String>(
                          title: const Text('Resep Tidak Lengkap'),
                          value: 'incomplete',
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        RadioListTile<String>(
                          title: const Text('Lainnya'),
                          value: 'other',
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Explain This Report:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      controller: explanationController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Jelaskan masalah pada resep ini...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Menutup modal
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Logika untuk mengirim laporan
              print('Alasan: $selectedReason');
              print('Penjelasan: ${explanationController.text}');
              Navigator.of(context).pop(); // Menutup modal setelah laporan dikirim
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Laporan berhasil dikirim')),
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      );
    },
  );
}
