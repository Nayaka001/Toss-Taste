import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://your-backend-url.com/api'; // Ganti dengan URL backend Anda

  Future<Map<String, dynamic>> register(String username, String gender, String email, String password, String confirmPassword) async {
    final url = Uri.parse('$baseUrl/register');  // Endpoint register di backend Anda
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'gender': gender,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Registration successful'};
    } else {
      final errorData = json.decode(response.body);
      return {'success': false, 'message': errorData['error'] ?? 'Registration failed'};
    }
  }
  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed: ${response.body}"); // Error login
    }
  }

}
