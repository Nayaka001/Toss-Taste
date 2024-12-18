class RecipeItem {
  final int recipeItemId;
  final String ingredientName;

  RecipeItem({
    required this.recipeItemId,
    required this.ingredientName,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    return RecipeItem(
      recipeItemId: json['recipe_item_id'],
      ingredientName: json['ingredient_name'] ?? '',
    );
  }
}
