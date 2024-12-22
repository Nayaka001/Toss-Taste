import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:jualan/App/models/constant.dart';
import 'package:jualan/App/models/users.dart';

Future<ApiResponse> login (String username, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'username': username, 'password': password}
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    switch(response.statusCode){
      case 200:
        apiResponse.data = Users.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
    print('Error: $e');
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> register (String username, String name, String gender, String password, String email) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
        Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {
          'username': username,
          'name': name,
          'gender': gender,
          'password': password,
          'password_confirmation': password,
          'email': email
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = Users.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getUsersDetail () async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
        Uri.parse(loginURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = Users.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('user_id') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.remove('token');
}

