import 'package:flutter/material.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1), // Light beige background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF7F1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Saved',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 150 / 190, // Aspect ratio for the cards
          ),
          itemCount: 9, // Number of items in the grid
          itemBuilder: (context, index) {
            return const SavedCard();
          },
        ),
      ),

    );
  }
}

class SavedCard extends StatelessWidget {
  const SavedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Lebar kartu
      height: 190, // Tinggi kartu
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5), // Border hitam untuk kartu
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        elevation: 2,
        margin: EdgeInsets.zero, // Menghapus margin default pada kartu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan kolom
          children: [
            const SizedBox(height: 8), // Jarak antara kartu dan gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(35.0)),
              child: Container(
                width: 160, // Lebar gambar
                height: 150, // Tinggi gambar yang diperbarui
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5), // Border hitam untuk seluruh gambar
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(35.0)),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/imgayam.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4), // Jarak antara gambar dan teks
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Menyelaraskan teks ke kiri
              children: [
                Text(
                  'Ayam Bawang',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Ukuran font untuk nama
                ),
                Text(
                  '20 mins',
                  style: TextStyle(color: Colors.black, fontSize: 18), // Ukuran font untuk waktu
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




