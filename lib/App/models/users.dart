class Users {
  int? user_id;
  String username;
  String name;
  String gender;
  String password;
  String email;
  String token;

  Users({
    this.user_id,
    required this.username,
    required this.name,
    required this.gender,
    required this.password,
    required this.email,
    required this.token,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      user_id: json['user_id'],
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'username': username,
      'name': name,
      'gender': gender,
      'password': password,
      'email': email,
      'token' :token,
    };
  }
}
