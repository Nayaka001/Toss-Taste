import 'package:intl/intl.dart';

class Recipes {
  final int recipeId;
  final String recipe_name;
  final String waktu_pembuatan;
  final int serve;
  final String description;
  final int createdBy;
  final String? image;
  final DateTime createdAt;

  Recipes({
    required this.recipeId,
    required this.recipe_name,
    required this.waktu_pembuatan,
    required this.serve,
    required this.description,
    required this.createdBy,
    this.image,
    required this.createdAt,
  });

  // Konversi dari JSON
  factory Recipes.fromJson(Map<String, dynamic> json) {
    // Cek jika 'created_at' ada dan valid
    String createdAtStr = json['created_at'] ?? '';
    DateTime createdAtDate;

    try {
      // Coba konversi jika 'created_at' ada
      if (createdAtStr.isNotEmpty) {
        createdAtDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(createdAtStr);
      } else {
        // Jika tidak ada, gunakan DateTime default
        createdAtDate = DateTime.now();
      }
    } catch (e) {
      // Jika terjadi error parsing, tetapkan nilai default
      createdAtDate = DateTime.now();
    }

    return Recipes(
      recipeId: json['recipe_id'],
      recipe_name: json['recipe_name'],
      waktu_pembuatan: json['waktu_pembuatan'],
      serve: json['serve'],
      description: json['description'],
      createdBy: json['created_by'],
      image: json['image'] ?? 'assets/images/imgayam.png',
      createdAt: createdAtDate, // Assign DateTime yang sudah dikonversi
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'recipe_id': recipeId,
      'recipe_name': recipe_name,
      'waktu_pembuatan': waktu_pembuatan,
      'serve': serve,
      'description': description,
      'created_by': createdBy,
      'image': image,
      'created_at': DateFormat("yyyy-MM-dd HH:mm:ss").format(createdAt), // Mengonversi kembali ke format string
    };
  }
}
