import 'package:flutter/material.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/navbar.dart';
import 'api_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ApiService apiService = ApiService();

  void registerUser() async {
    final username = usernameController.text;
    final gender = genderController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final result = await apiService.register(username, gender, email, password, confirmPassword);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.green),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavbar(currentIndex: 0)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/images/toplog.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
          Center(
            child: Column(
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    'Create your account and let your mood guide your taste!',
                    style: TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 38),
                buildTextField('Name', usernameController, 'assets/images/nama.png'),
                const SizedBox(height: 16),
                buildTextField('Gender', genderController, 'assets/images/gender.png'),
                const SizedBox(height: 16),
                buildTextField('Email', emailController, 'assets/images/letter.png'),
                const SizedBox(height: 16),
                buildTextField('Username', usernameController, 'assets/images/male.png'),
                const SizedBox(height: 16),
                buildTextField('Password', passwordController, 'assets/images/pass.png'),
                const SizedBox(height: 16),
                buildTextField('Confirm Password', confirmPasswordController, 'assets/images/pass.png'),
                const SizedBox(height: 16),
                Container(
                  width: 280,
                  height: 54,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFFFBF69),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller, String iconPath) {
    return Container(
      width: 280,
      height: 39,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11.0),
            child: Image.asset(iconPath, width: 30, height: 200, fit: BoxFit.cover),
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
