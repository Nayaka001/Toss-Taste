class RecipeDetail {
  final int recipeId;
  final String recipeName;
  final String waktuPembuatan;
  final int serve;
  final String description;
  final String image;
  final User createdBy;
  final List<Review> comments;
  final List<IngredientCategory> categories;
  final double averageRating;

  RecipeDetail({
    required this.recipeId,
    required this.recipeName,
    required this.waktuPembuatan,
    required this.serve,
    required this.description,
    required this.image,
    required this.createdBy,
    required this.comments,
    required this.categories,
    required this.averageRating,
  });
  int get totalItems {
    int total = 0;
    for (var category in categories) {
      for (var subcategory in category.subcategories) {
        total += subcategory.items.length;
      }
    }
    return total;
  }

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      recipeId: json['recipe']['recipe_id'],
      recipeName: json['recipe']['recipe_name'],
      waktuPembuatan: json['recipe']['waktu_pembuatan'],
      serve: json['recipe']['serve'],
      description: json['recipe']['description'],
      image: json['recipe']['image'],
      createdBy: User.fromJson(json['recipe']['created_by']),
      comments: (json['comments']['data'] as List)
          .map((comment) => Review.fromJson(comment))
          .toList(),
      categories: (json['categories'] as List)
          .map((category) => IngredientCategory.fromJson(category))
          .toList(),
      averageRating: json['recipe']['average_rating'] != null &&
          json['recipe']['average_rating'].toString().isNotEmpty
          ? double.tryParse(json['recipe']['average_rating'].toString()) ?? 0.0
          : 0.0,

// Pastikan nilai rating yang diterima diubah menjadi double
    );
  }
}

class User {
  final int userId;
  final String name;

  User({
    required this.userId,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'],
    );
  }
}

class Review {
  final int reviewId;
  final int recipeId;
  final int userId;
  final int rating;
  final String comment;
  final String reviewedAt;
  final User user;

  Review({
    required this.reviewId,
    required this.recipeId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.reviewedAt,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
      rating: json['rating'],
      comment: json['comment'],
      reviewedAt: json['reviewed_at'],
      user: User.fromJson(json['user']),
    );
  }
}

class IngredientCategory {
  final int categoryId;
  final String categoryName;
  final String image;
  final List<SubCategory> subcategories;

  IngredientCategory({
    required this.categoryId,
    required this.categoryName,
    required this.image,
    required this.subcategories,
  });

  factory IngredientCategory.fromJson(Map<String, dynamic> json) {
    return IngredientCategory(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      image: json['image'],
      subcategories: (json['subcategory'] as List)
          .map((sub) => SubCategory.fromJson(sub))
          .toList(),
    );
  }
}

class SubCategory {
  final int subcategoryId;
  final String subcategoryName;
  final int categoryId;
  final List<Item> items;

  SubCategory({
    required this.subcategoryId,
    required this.subcategoryName,
    required this.categoryId,
    required this.items,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subcategoryId: json['subcategory_id'],
      subcategoryName: json['subcategory_name'],
      categoryId: json['category_id'],
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}

class Item {
  final int itemId;
  final String itemName;
  final int subcategoryId;

  Item({
    required this.itemId,
    required this.itemName,
    required this.subcategoryId,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      itemName: json['nama_item'],
      subcategoryId: json['subcategory_id'],
    );
  }
}
