import 'package:jualan/App/models/item.dart';

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
      items: (json['items'] as List)
          .map((itemJson) => Item.fromJson(itemJson))
          .toList(),
    );
  }
}
