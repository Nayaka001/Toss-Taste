class Favorite {
  final int userId;
  final int recipeId;
  final String addedAt;

  Favorite({
    required this.userId,
    required this.recipeId,
    required this.addedAt,
  });

  // Mengonversi JSON menjadi objek Favorite
  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      userId: json['user_id'],
      recipeId: json['recipe_id'],
      addedAt: json['added_at'],
    );
  }

  // Mengonversi objek Favorite menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'recipe_id': recipeId,
      'added_at': addedAt,
    };
  }
}
