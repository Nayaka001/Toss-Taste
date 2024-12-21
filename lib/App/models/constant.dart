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
const comments =  '$baseURL/comment';
String getRecipeURL(int recipeId) {
  return '$baseURL/recipes/$recipeId/recipes';
}

//Error
const serverError = 'Server Error';
const somethingWentWrong = 'Something Went Wrong';
const unauthorized = 'Unauthorized';