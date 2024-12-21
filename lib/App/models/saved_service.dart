import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/users_service.dart';

class FavoritesService {
  static Future<void> submitReview({
    required int recipeId,
    required int rating,
    required String comment,
  }) async {
    final userId = await getUserId(); // Ambil ID user dari login atau penyimpanan lokal
    final url = Uri.parse(comments); // Ganti dengan URL API Laravel Anda
    String token = await getToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Jika menggunakan token auth
      },
      body: jsonEncode({
        'user_id': userId,
        'recipe_id': recipeId,
        'rating': rating,
        'comment': comment,
      }),
    );
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 201) {
      // Berhasil mengirim review
      print('Review submitted successfully!');
    } else {
      // Gagal mengirim review
      print('Failed to submit review: ${response.body}');
    }
  }
    // Fungsi untuk menambahkan favorit
  static Future<void> addFavorite(int recipeId) async {
    final url = Uri.parse(saved);
    String token = await getToken();
    print('Token: $token');  // Debug token yang dikirimkan

    int? userId = await getUserId();
    print('User ID: $userId'); // Debug user_id
    // Permintaan POST ke API
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Ganti dengan token autentikasi pengguna
      },
      body: jsonEncode({
        'user_id': userId,
        'recipe_id': recipeId,
      }),
    );

    // Debug response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      print('Favorite added successfully!');
    } else {
      print('Failed to add favorite: ${response.body}');
    }
  }
}
