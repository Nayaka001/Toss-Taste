import 'package:jualan/App/models/recipes.dart';

class Likes {
  final int likeId;
  final int userId;
  final int recipeId;
  final String addedAt;
  late final Recipes recipe;

  Likes({
    required this.likeId,
    required this.userId,
    required this.recipeId,
    required this.addedAt,
    required this.recipe,
  });

  // Mengonversi JSON menjadi objek Likes tanpa parameter Recipes
  factory Likes.fromJson(Map<String, dynamic> json) {
    return Likes(
      likeId: json['like_id'],
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      addedAt: json['added_at'],
      recipe: Recipes(
        recipeId: json['recipe_id'],
        recipe_name: json['recipe_name'] ?? '',
        waktu_pembuatan: json['waktu_pembuatan'] ?? '',
        serve: json['serve'] ?? 0,
        description: json['description'] ?? '',
        createdBy: json['created_by'] ?? 0,
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      ), // Memberikan nilai default untuk recipe jika tidak ada
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'like_id': likeId,
      'user_id': userId,
      'recipe_id': recipeId,
      'added_at': addedAt,
    };
  }
}
