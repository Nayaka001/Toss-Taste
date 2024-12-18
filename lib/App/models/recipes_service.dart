import 'dart:convert';

import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/category.dart';
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/models/recipes.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getMenu() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    print("Token: $token");

    // Menambahkan print untuk mengecek URL request
    print("Request URL: $menuURL");

    final response = await http.get(
      Uri.parse(menuURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Response body: ${response.body}");
    var responseData = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        if (responseData.containsKey('menu_hari_ini')) {
          apiResponse.data = responseData['menu_hari_ini']
              .map((p) => Recipes.fromJson(p))
              .toList();
        } else {
          apiResponse.error = 'menu_hari_ini key not found in response';
        }
        break;
      case 422:
        final errors = responseData['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = responseData['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    print("Error occurred: $e");
  }
  return apiResponse;
}
Future<ApiResponse> getIngredients() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    print("Token: $token");

    // Menambahkan print untuk mengecek URL request
    print("Request URL: $ingredientUrl");

    final response = await http.get(
      Uri.parse(ingredientUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Response body: ${response.body}");
    var responseData = jsonDecode(response.body);
    print("Response body: ${response.body}");
    switch (response.statusCode) {
      case 200:
        if (responseData['ingredients'] != null) {
          List<IngredientsCategory> categories = (responseData['ingredients'] as List)
              .map((categoryJson) => IngredientsCategory.fromJson(categoryJson))
              .toList();

          // You can return the categories or assign them to a property
          apiResponse.data = categories;  // Storing categories in apiResponse
        } else {
          apiResponse.error = 'ingredients key not found in response';
        }
        break;
      case 422:
        final errors = responseData['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = responseData['message'];
        break;
      default:
        apiResponse.error = 'Something went wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error';
    print("Error occurred: $e");
  }
  return apiResponse;
}
Future<List<Recipes>> fetchRecipesByItems(List<String> selectedItems) async {
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(hasilResep),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'selected_items': selectedItems}),
    );

    if (response.statusCode == 200) {
      // Decode response JSON
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('recipes')) {
        final List<dynamic> recipesJson = responseData['recipes'];
        return recipesJson.map((recipe) => Recipes.fromJson(recipe)).toList();
      } else {
        throw Exception('Recipes key not found in response');
      }
    } else if (response.statusCode == 422) {
      throw Exception('Invalid input data');
    } else if (response.statusCode == 403) {
      throw Exception('Unauthorized request');
    } else {
      throw Exception(somethingWentWrong);
    }
  } catch (e) {
    throw Exception('Error fetching recipes: $e');
  }
}
Future<ApiResponse> addRecipe(Recipes recipe) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Mendapatkan token pengguna
    String token = await getToken();
    print("Token: $token");

    // URL untuk endpoint `addRecipe`
    const String addRecipeURL = 'https://example.com/api/recipes';

    // Menyiapkan data body untuk dikirim
    Map<dynamic, dynamic> recipeData = recipe.toJson();
    print("Request Data: $recipeData");

    // Melakukan permintaan POST ke server
    final response = await http.post(
      Uri.parse(addRecipeURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(recipeData),
    );

    print("Response body: ${response.body}");
    var responseData = jsonDecode(response.body);

    // Menangani response berdasarkan kode status
    switch (response.statusCode) {
      case 201: // Created
        apiResponse.data = Recipes.fromJson(responseData);
        break;
      case 422: // Validation error
        final errors = responseData['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403: // Unauthorized
        apiResponse.error = responseData['message'];
        break;
      default: // Error lainnya
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    print("Error occurred: $e");
  }
  return apiResponse;
}
