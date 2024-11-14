import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jualan/App/navbar.dart';
import 'register.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatelessWidget{
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: TextField(
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
            child: TextField(
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
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Container(
                              width: 200,
                              height: 54,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: ElevatedButton(onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavbar(currentIndex: 0,)));
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
    );
  }

}