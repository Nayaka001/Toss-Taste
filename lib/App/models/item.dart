import 'recipeitem.dart';

class Item {
  int? itemId;
  String itemName;
  int? subcategoryId;
  List<RecipeItem>? recipeItems;

  Item({
    this.itemId,
    required this.itemName,
    this.subcategoryId,
    this.recipeItems,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'],
      itemName: json['nama_item'] ?? '',
      subcategoryId: json['subcategory_id'],
      recipeItems: json['recipe_items'] != null
          ? (json['recipe_items'] as List)
          .map((recipeItemJson) => RecipeItem.fromJson(recipeItemJson))
          .toList()
          : [],
    );
  }
}
