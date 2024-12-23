import 'package:jualan/App/models/users_service.dart';

const baseURL = 'http://10.0.2.2:8000/api';
const registerURL = '$baseURL/register';
const loginURL = '$baseURL/login';
const menuURL = '$baseURL/menu';
const ingredientUrl = '$baseURL/ingredients-details';
const hasilResep = '$baseURL/recipes-by-items';
const addRecipes = '$baseURL/add-recipe';
const search = '$baseURL/search-recipes';
const getLogUser =  '$baseURL/user';
const saved =  '$baseURL/saved';
Future<String> getFav(int recipeId) async {
  int? userId = await getUserId();
  return '$baseURL/favorites/$userId';
}
Future<String> getLike(int recipeId) async {
  int? userId = await getUserId();
  return '$baseURL/likes/$userId';
}
const comments =  '$baseURL/comment';
Future<String> getRecipesUrl() async {
  int? userId = await getUserId(); // Menunggu hingga userId tersedia
  return '$baseURL/recipes/$userId'; // Menggunakan userId dalam URL
}

String getRecipeURL(int recipeId) {
  return '$baseURL/recipes/$recipeId/recipes';
}

//Error
const serverError = 'Server Error';
const somethingWentWrong = 'Something Went Wrong';
const unauthorized = 'Unauthorized';