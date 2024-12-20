import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jualan/App/models/api_service.dart';
import 'package:jualan/App/models/users.dart';
import 'package:jualan/App/models/users_service.dart';
import 'package:jualan/App/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';

class Login extends StatefulWidget{
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login>{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void loginUser() async {
    try {
      ApiResponse response = await login(txtUsername.text, txtPassword.text);
      print('Response: ${response.data}, Error: ${response.error}'); // Tambahkan log untuk debugging
      if (response.error == null) {
        _saveToken(response.data as Users);
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unexpected error occurred: $e'), // Menangani error yang tidak terduga
      ));
      // print('Login Error: $e'); // Debug log
      // print('Username: ${txtUsername.text}, Password: ${txtPassword.text}');
    }
  }



  void _saveToken(Users user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('user_id', user.user_id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const BottomNavbar(currentIndex: 0,)), (route)=> false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Image.asset('assets/images/toplog.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
            const Text('Sign In', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            const SizedBox(height: 17,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 51),
              child: const Text('Create your account and let your mood guide your taste!',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 65,),
            Container(
              width: 290,
              height: 39,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)
              ),
              alignment: Alignment.center,
              child: TextFormField(
                  controller: txtUsername,
                  validator: (val) => val!.isEmpty ? 'Username tidak valid' : null,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.asset(
                        'assets/images/male.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    hintText: "Username",
                    // labelText: "Username",
                    hintStyle: const TextStyle(
                      color: Colors.black
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
              ),
            ),
            const SizedBox(height: 24,),

            Container(
              width: 290,
              height: 39,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)
              ),
              alignment: Alignment.center,
              child: TextFormField(
                controller: txtPassword,
                validator: (val) => val!.isEmpty ? 'Password minimal 8 characters' : null,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'assets/images/pass.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  hintText: "Password",
                  hintStyle: const TextStyle(
                      color: Colors.black
                  ),
                  suffixIcon: Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'assets/images/eye.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 87,),
            Stack(
              children: [
                Image.asset('assets/images/botlog.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(top: 108),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don’t have account ? ', style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  )
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                                      },
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17,
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                        ),
                                      )
                                  )
                                ]
                            ),
                            loading? const Center(child: CircularProgressIndicator(),):
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Container(
                                width: 200,
                                height: 54,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: TextButton(
                                    onPressed: () {
                                  if(formKey.currentState!.validate()){
                                    setState(() {
                                      loading = true;
                                      loginUser();
                                    });
                                  }
                                },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFFFFBF69),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50), // Border radius tombol
                                      ),
                                    ),
                                    child: const Text('Sign In',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))),
                              ),
                            )
        
                          ],
                        )
                    )
        
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}