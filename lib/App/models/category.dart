class IngredientsCategory {
  final String categoryName;
  final String image;
  final List<SubCategory> subcategories;

  IngredientsCategory({
    required this.categoryName,
    required this.image,
    required this.subcategories,
  });

  factory IngredientsCategory.fromJson(Map<String, dynamic> json) {
    return IngredientsCategory(
      categoryName: json['category_name'] ?? '',
      image: json['image'] ?? '',
      subcategories: (json['subcategory'] as List<dynamic>?)
          ?.map((sub) => SubCategory.fromJson(sub))
          .toList() ??
          [],
    );
  }
}

class SubCategory {
  final String subcategoryName;
  final List<Item> items;

  SubCategory({
    required this.subcategoryName,
    required this.items,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subcategoryName: json['subcategory_name'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => Item.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class Item {
  final int item_id;
  final String namaItem;

  Item({required this.item_id, required this.namaItem});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      item_id: json['item_id'] ?? 0, // Pastikan `id` ada di JSON
      namaItem: json['nama_item'] ?? '',
    );
  }
}
