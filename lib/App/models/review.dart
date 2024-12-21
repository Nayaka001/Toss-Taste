import 'package:jualan/App/models/users.dart';

import 'recipes.dart'; // Pastikan import model Recipes

class Review {
  final int reviewId;
  final int userId;
  final int rating;
  final String comment;
  final String reviewedAt;
  final Recipes recipe; // Relasi dengan Recipes
  final Users user; // Relasi dengan User

  Review({
    required this.reviewId,
    required this.recipe,
    required this.user,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.reviewedAt,
  });

  // Factory untuk membuat objek Review dari JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'],
      recipe: Recipes.fromJson(json['recipe']), // Parsing objek Recipes
      user: Users.fromJson(json['user']), // Parsing objek User
      userId: json['user_id'],
      rating: json['rating'],
      comment: json['comment'],
      reviewedAt: json['reviewed_at'],
    );
  }

  // Method untuk mengonversi objek Review ke JSON
  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'recipe': recipe.toJson(), // Konversi objek Recipes ke JSON
      'user': user.toJson(), // Konversi objek User ke JSON
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'reviewed_at': reviewedAt,
    };
  }
}

