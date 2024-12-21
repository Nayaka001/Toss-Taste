class Recipes {
  final int recipeId;
  final String recipe_name;
  final String waktu_pembuatan;
  final int serve;
  final String description;
  final int createdBy;
  final String? image; // Tambahkan atribut `image`

  Recipes({
    required this.recipeId,
    required this.recipe_name,
    required this.waktu_pembuatan,
    required this.serve,
    required this.description,
    required this.createdBy,
    this.image, // Tambahkan atribut opsional
  });

  // Konversi dari JSON
  factory Recipes.fromJson(Map<String, dynamic> json) {
    return Recipes(
      recipeId: json['recipe_id'],
      recipe_name: json['recipe_name'],
      waktu_pembuatan: json['waktu_pembuatan'],
      serve: json['serve'],
      description: json['description'],
      createdBy: json['created_by'],
      image: json['image'] ?? 'assets/images/imgayam.png', // Nilai default
    );
  }


  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'recipe_id': recipeId,
      'recipe_name': recipe_name,
      'waktu_pembuatan': waktu_pembuatan,
      'serve': serve,
      'description': description,
      'created_by': createdBy,
      'image': image, // Tambahkan `image` di sini
    };
  }
}
