import 'package:jualan/App/models/recipes.dart';

class Favorite {
  final int favId;
  final int userId;
  final int recipeId;
  final String addedAt;
  late final Recipes recipe;

  Favorite({
    required this.favId,
    required this.userId,
    required this.recipeId,
    required this.addedAt,
    required this.recipe,
  });

  // Mengonversi JSON menjadi objek Favorite tanpa parameter Recipes
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favId: json['fav_id'],
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      addedAt: json['added_at'],
      recipe: Recipes(recipeId: json['recipe_id'], recipe_name: '', waktu_pembuatan: '', serve: 0, description: '', createdBy: 0, createdAt: DateTime.now()), // Memberikan nilai default untuk recipe
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fav_id': favId,
      'user_id': userId,
      'recipe_id': recipeId,
      'added_at': addedAt,
    };
  }
}
